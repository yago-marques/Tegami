//
//  MainScreenViewModel.swift
//  GhibliAPP
//
//  Created by Yago Marques on 12/09/22.
//

import Foundation

final class MainScreenViewModel {
    let apiService = APICall()

    func fetchFilms() async -> [FilmModel]? {


        return []
    }

    func fetchGhibliInfo() async -> [GhibliInfo]? {
        guard let apiInfo = await apiService.GET(at: "https://ghibliapi.herokuapp.com/films") else {
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
            at: "https://api.themoviedb.org/3/search/movie",
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
}
