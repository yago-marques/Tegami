//
//  FilmService.swift
//  Tegami
//
//  Created by Yago Marques on 13/10/22.
//

import Foundation

enum DomainError: Error {
    case invalidData
    case requestError
}

final class RemoteFilmLoader: FilmLoader {
    
    private let api: HTTPClient
    private var ghibliInfos: [GhibliInfo] = []
    private var tmdbResults: [TmdbResult] = []
    private var genres: [GenreInfo] = []
    
    init(api: HTTPClient) {
        self.api = api
    }
        
    func getFilms(completion: @escaping (Result<[Film], Error>) -> Void) {
        fetchGhibliInfos { [weak self] in
            guard let self = self else { return }
            self.ghibliInfos.forEach {
                self.fetchTmdbInfo(for: $0.originalTitle) {
                    completion(self.makeFilms())
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchGhibliInfos(completion: @escaping () -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        api.get(endpoint: GhibliFilmsEndpoint()) { [weak self] result in
            guard let self = self else { return }
            
            if case let .success((data, response)) = result {
                guard response.statusCode == 200, let infos = try? decoder.decode([GhibliInfo].self, from: data) else { return }
                self.ghibliInfos = infos
            }
            
            completion()
        }
    }
    
    private func fetchTmdbInfo(for title: String, completion: @escaping () -> Void) {
        let endpoint = TmdbInfoEndpoint(title: title)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        api.get(endpoint: endpoint) { [weak self] result in
            guard let self = self else { return }
            
            if case let .success((data, response)) = result {
                guard response.statusCode == 200, let tmdbInfo = try? decoder.decode(TmdbInfo.self, from: data) else { return }
                self.tmdbResults.append(tmdbInfo.results[0])
            }
            
            if self.tmdbResults.count == self.ghibliInfos.count {
                self.fetchGenres(completion: completion)
            }
            
        }
    }
    
    private func fetchGenres(completion: @escaping () -> Void) {
        let endpoint = TmdbGenreEndpoint()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        api.get(endpoint: endpoint) { [weak self] result in
            guard let self = self else { return }
            
            if case let .success((data, response)) = result {
                guard response.statusCode == 200, let model = try? decoder.decode(GenreModel.self, from: data) else { return }
                self.genres = model.genres
            }
            
            completion()
        }
    }
    
    private func makeFilms() -> Result<[Film], Error> {
        if ghibliInfos.isEmpty {
            return .failure(DomainError.invalidData)
        }
        
        let models = self.ghibliInfos.enumerated().map { (index, value) in
            FilmModel(ghibli: value, tmdb: self.tmdbResults[index])
        }

        let films = models.map {
            Film(
                id: $0.ghibli.id,
                title: $0.ghibli.originalTitle,
                posterImage: Data(),
                runningTime: $0.ghibli.runningTime,
                releaseDate: $0.ghibli.releaseDate,
                genres: "Desconhecido",
                bannerImage: Data(),
                description: $0.tmdb.overview,
                popularity: $0.tmdb.popularity)
        }
        
        return .success(films)
    }
}
