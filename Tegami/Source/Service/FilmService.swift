//
//  FilmService.swift
//  Tegami
//
//  Created by Yago Marques on 13/10/22.
//

import Foundation

protocol FilmServicing {
    func getFilms(completion: @escaping (Result<[Film],Error>) -> Void)
}

final class FilmService: FilmServicing {

    func getFilms(completion: @escaping (Result<[Film],Error>) -> Void) {

    }

    func fetchGhibliInfo(completion: @escaping (Result<[GhibliInfo], Error>) -> Void) {
        delegate?.isInterective(false)

        apiService.GET(at: UrlEnum.ghibliUrl.rawValue) { [weak self] result in
            if let self = self {
                switch result {
                case .success(let (data, _)):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let ghibliInfo = try decoder.decode([GhibliInfo].self, from: data)
                        self.delegate?.isInterective(true)
                        completion(.success(ghibliInfo))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }

    func fetchTmdbInfo(
        originalTitle: String,
        completion: @escaping (Result<TmdbResult?, Error>) -> Void
    ) {

        apiService.GET(
            at: UrlEnum.tmbdMovie.rawValue,
            queries: [
                ("api_key", "2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language", "pt-BR"),
                ("query", originalTitle),
                ("page", "1")
            ]
        ) { [weak self] result in
            if let self = self {
                switch result {
                case .success(let (data, _)):
                    do {
                        let tmdbInfo = try JSONDecoder().decode(TmdbInfo.self, from: data)
                        self.transformGenres(ids: tmdbInfo.results.first!.genreIds) { genreResult in
                            switch genreResult {
                            case .success(let stringGenreList):
                                tmdbInfo.results.first?.genreNames = stringGenreList
                                completion(.success(tmdbInfo.results.first))
                            case .failure(let failure):
                                completion(.failure(failure))
                            }
                        }

                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
    }

    func fetchGenres(completion: @escaping (Result<[GenreInfo], Error>) -> Void) {

        apiService.GET(
            at: UrlEnum.tmdbGenre.rawValue,
            queries: [
                ("api_key","2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language","pt-BR")
            ]
        ) { result in
            switch result {
            case .success(let (data, _)):
                do {
                    let genreInfo = try JSONDecoder().decode(GenreModel.self, from: data)
                    completion(.success(genreInfo.genres))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }

    }

    func transformGenres(
        ids: [Int],
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        self.fetchGenres { result in
            switch result {
            case .success(let genreTable):
                let idsToTransform: [Int] = ids.count >= 2 ? [ids[0], ids[1]] : [ids[0]]

                let genreNames: [String] = idsToTransform.map { id in
                    var genreName = "unknown"
                    for genre in genreTable where genre.id == id {
                        genreName = genre.name
                    }
                    return genreName
                }

                completion(.success(genreNames))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }

    }

}
