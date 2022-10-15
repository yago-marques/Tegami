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
    private var posters: [Data] = []
    private var banners: [Data] = []
    
    init(api: HTTPClient) {
        self.api = api
    }
        
    func getFilms(completion: @escaping (Result<[Film], Error>) -> Void) {
        fetchGhibliInfos { [weak self] in
            guard let self = self else { return }
            self.ghibliInfos.forEach {
                self.fetchTmdbInfo(for: $0.originalTitle) {
                    self.fetchPosterImages {
                        self.fetchBannersImages {
                            completion(self.makeFilms())
                        }
                    }
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
        
        api.get(endpoint: endpoint) { [weak self] result in
            guard let self = self else { return }
            
            if case let .success((data, response)) = result {
                guard response.statusCode == 200, let tmdbInfo = try? JSONDecoder().decode(TmdbInfo.self, from: data) else { return }
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
    
    func fetchPosterImages(completion: @escaping () -> Void) {
        tmdbResults.forEach {
            fetchImage(with: $0.posterPath) { [weak self] data in
                guard let self = self else { return }
                guard let data = data else { return }
                self.posters.append(data)
                
                if self.posters.count == 22 {
                    completion()
                }
            }
        }
    }
    
    func fetchBannersImages(completion: @escaping () -> Void) {
        tmdbResults.forEach {
            fetchImage(with: $0.backdropPath) { [weak self] data in
                guard let self = self else { return }
                guard let data = data else { return }
                self.banners.append(data)
                
                if self.banners.count == 22 {
                    completion()
                }
            }
        }
    }
    
    private func fetchImage(with imagePath: String, completion: @escaping (Data?) -> Void) {
        let endpoint = TmdbImageEndpoint(imagePath: imagePath)
        guard let url = endpoint.makeURL() else {
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        
        completion(data)
    }
    
    private func makeFilms() -> Result<[Film], Error> {
        if ghibliInfos.isEmpty {
            return .failure(DomainError.invalidData)
        }
        
        let models = self.ghibliInfos.enumerated().map { (index, value) in
            FilmModel(ghibli: value, tmdb: self.tmdbResults[index])
        }

        let films = models.enumerated().map { (index, value) in
            Film(
                id: value.ghibli.id,
                title: value.ghibli.originalTitle,
                posterImage: posters[index],
                runningTime: value.ghibli.runningTime,
                releaseDate: value.ghibli.releaseDate,
                genre: "Desconhecido",
                bannerImage: banners[index],
                description: value.tmdb.overview,
                popularity: value.tmdb.popularity)
        }
        
        return .success(films)
    }
}
