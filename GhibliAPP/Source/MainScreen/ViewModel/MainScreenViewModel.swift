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

    func fetchFilms() async -> [FilmModel]? {
        guard let ghibliInfo = await self.fetchGhibliInfo() else { return nil }

        let films: [FilmModel] = await ghibliInfo.asyncMap { ghibliFilm -> FilmModel in
            let tmdbInfo = await fetchTmdbInfo(originalTitle: ghibliFilm.originalTitle)
            let filmInfo = FilmModel(ghibli: ghibliFilm, tmdb: tmdbInfo ?? nil)
            return filmInfo
        }

        return films
    }

    func fetchGhibliInfo() async -> [GhibliInfo]? {
        guard let apiInfo = await apiService.GET(at: UrlEnum.ghibliUrl.rawValue) else {
            return nil
        }

        do {
            let ghibliInfo = try JSONDecoder().decode([GhibliInfo].self, from: apiInfo.data)
            return ghibliInfo
        } catch {
            print(error)
        }

        return nil
    }

    func fetchTmdbInfo(originalTitle: String) async -> TmdbResult? {
        guard let apiInfo = await apiService.GET(
            at: UrlEnum.tmbdMovie.rawValue,
            queries: [
                ("api_key", "2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language", "pt-BR"),
                ("query", originalTitle),
                ("page", "1")
            ]
        ) else {
            return nil
        }

        do {
            let tmdbInfo = try JSONDecoder().decode(TmdbInfo.self, from: apiInfo.data)
            return tmdbInfo.results.first
        } catch {
            print(error)
        }

        return nil
    }

    func fetchGenres() async -> [GenreInfo]? {
        guard let apiInfo = await apiService.GET(
            at: UrlEnum.tmdbGenre.rawValue,
            queries: [
                ("api_key","2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language","pt-BR")
            ]
        ) else {
            return nil
        }
        do {
            let genreInfo = try JSONDecoder().decode(GenreModel.self, from: apiInfo.data)
            return genreInfo.genres
        } catch {
            print(error)
        }

        return nil
    }

    func transformGeneres(ids: [Int]) async -> [String]? {
        guard let genreTable = await fetchGenres() else { return nil }
        var idsToTransform: [Int] = []
        var genreNames: [String] = []

        if ids.count >= 2{
            idsToTransform = [ids[0], ids[1]]
        }else{
            idsToTransform = [ids[0]]
        }

        for genre in genreTable {

        }

        return nil
    }

}
