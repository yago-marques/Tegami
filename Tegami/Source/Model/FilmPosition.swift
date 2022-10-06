//
//  FilmList.swift
//  GhibliAPP
//
//  Created by Yago Marques on 19/09/22.
//

import Foundation

struct FilmPosition: Codable, Equatable {
    let filmId: String

    static func positionMock() -> [FilmPosition] {
        return [
            FilmPosition(filmId: "2baf70d1-42bb-4437-b551-e5fed5a87abe"),
            FilmPosition(filmId: "12cfb892-aac0-4c5b-94af-521852e46d6a"),
            FilmPosition(filmId: "58611129-2dbc-4a81-a72f-77ddfc1b1b49"),
            FilmPosition(filmId: "ea660b10-85c4-4ae3-8a5f-41cea3648e3e")
        ]
    }

    static func newFilmPosition() -> FilmPosition {
        return FilmPosition(filmId: "1b67aa9a-2e4a-45af-ac98-64d6ad15b16c")
    }
}
