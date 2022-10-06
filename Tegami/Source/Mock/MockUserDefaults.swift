//
//  MockUserDefaults.swift
//  Tegami
//
//  Created by Yago Marques on 04/10/22.
//

import Foundation

class MockUserDefaults: UserDefaults {
    private(set) var setFilmList = false
    private(set) var setWatchedFilms = false
    private(set) var setOnboarding = false

    convenience init() {
        self.init(suiteName: "Tegami")!
    }

    override init?(suiteName suitename: String?) {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }

    override func set(_ value: Any?, forKey defaultName: String) {
        switch defaultName {
        case "filmList":
            setFilmList = true
        case "watchedFilms":
            setWatchedFilms = true
        case "onboard":
            setOnboarding = true
        default:
            print("error")
        }
    }

    override func object(forKey defaultName: String) -> Any? {

        switch defaultName {
        case "filmList":
            let films: [FilmPosition] = [
                FilmPosition(filmId: "2baf70d1-42bb-4437-b551-e5fed5a87abe"),
                FilmPosition(filmId: "12cfb892-aac0-4c5b-94af-521852e46d6a"),
                FilmPosition(filmId: "58611129-2dbc-4a81-a72f-77ddfc1b1b49"),
                FilmPosition(filmId: "ea660b10-85c4-4ae3-8a5f-41cea3648e3e")
            ]

            let data = try? JSONEncoder().encode(films)

            return data
        case "watchedFilms":
            let array: [FilmPosition] = []
            return try? JSONEncoder().encode(array)
        case "invalidFilm" :
            let films: [FilmPosition] = [FilmPosition(filmId: "mock")]

            let data = try? JSONEncoder().encode(films)

            return data
        case "onboard":
            return try? JSONEncoder().encode(true)
        default:
            return nil
        }

    }

}
