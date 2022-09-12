//
//  FilmModel.swift
//  GhibliAPP
//
//  Created by Yago Marques on 09/09/22.
//

import Foundation

struct FilmModel {
    let ghibli: GhibliInfo
    let tmdb: TmdbInfo
}

struct GhibliInfo: Decodable {
    let id: String
    let releaseDate: String
    let runningTime: String
    let originalTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case releaseDate = "release_date"
        case runningTime = "running_time"
        case originalTitle = "original_title"
    }

}

struct TmdbInfo: Decodable {
    let results: [TmdbResult]
}

struct TmdbResult: Decodable {
    let id: Int
    let title: String
    let overview: String
    let popularity: Double
    let genreIds: [Int]
    let backdropPath: String
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}
