//
//  MainScreenViewModel.swift
//  GhibliAPP
//
//  Created by Yago Marques on 12/09/22.
//

import Foundation

final class MainScreenViewModel {
    let apiService: APICall

    init(apiService: APICall) {
        self.apiService = apiService
    }

    func fetchFilms(requestException: Bool = false) async -> [FilmModel]? {
        guard let ghibliInfo = !requestException ? await self.fetchGhibliInfo() : nil else { return nil }

        let films: [FilmModel] = await ghibliInfo.asyncMap { ghibliFilm -> FilmModel in
            let tmdbInfo = await fetchTmdbInfo(originalTitle: ghibliFilm.originalTitle)
            let filmInfo = FilmModel(ghibli: ghibliFilm, tmdb: tmdbInfo)
            return filmInfo
        }

        return films
    }

    func fetchGhibliInfo(requestException: Bool = false, decoderException: Bool = false) async -> [GhibliInfo]? {
        guard let apiInfo = !requestException ? await apiService.GET(at: UrlEnum.ghibliUrl.rawValue) : nil else {
            return nil
        }

        do {
            let data = !decoderException ? apiInfo.data : Data("decoderException".utf8)
            let ghibliInfo = try JSONDecoder().decode([GhibliInfo].self, from: data)
            return ghibliInfo
        } catch {
            print(error)
            return nil
        }
    }

    func fetchTmdbInfo(
        originalTitle: String,
        requestException: Bool = false,
        decoderException: Bool = false,
        genreException: Bool = false
    ) async -> TmdbResult? {
        guard let apiInfo = !requestException ? await apiService.GET(
            at: UrlEnum.tmbdMovie.rawValue,
            queries: [
                ("api_key", "2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language", "pt-BR"),
                ("query", originalTitle),
                ("page", "1")
            ]
        ) : nil else {
            return nil
        }
        
        do {
            let data = !decoderException ? apiInfo.data : Data("decoderException".utf8)
            let tmdbInfo = try JSONDecoder().decode(TmdbInfo.self, from: data)
            guard let stringGenreList = !genreException ? await transformGenres(
                ids: tmdbInfo.results.first!.genreIds
            ) : nil else {
                return nil
            }
            tmdbInfo.results.first?.genreNames = stringGenreList
            return tmdbInfo.results.first
        } catch {
            print(error)
            return nil
        }
    }

    func fetchGenres(requestException: Bool = false, decoderException: Bool = false ) async -> [GenreInfo]? {
        guard let apiInfo = !requestException ? await apiService.GET(
            at: UrlEnum.tmdbGenre.rawValue,
            queries: [
                ("api_key","2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language","pt-BR")
            ]
        ) : nil else {
            return nil
        }
        do {
            let data = !decoderException ? apiInfo.data : Data("decoderException".utf8)
            let genreInfo = try JSONDecoder().decode(GenreModel.self, from: data)
            return genreInfo.genres
        } catch {
            print(error)
            return nil
        }
    }

    func transformGenres(ids: [Int], requestException: Bool = false) async -> [String]? {
        guard let genreTable = !requestException ? await fetchGenres() : nil else { return nil }
        let idsToTransform: [Int] = ids.count >= 2 ? [ids[0], ids[1]] : [ids[0]]
        
        let genreNames: [String] = idsToTransform.map { id in
            var genreName = "unknow"
            for genre in genreTable where genre.id == id {
                genreName = genre.name
            }
            return genreName
        }

        return genreNames
    }

}
