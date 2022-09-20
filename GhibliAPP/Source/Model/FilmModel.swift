//
//  FilmModel.swift
//  GhibliAPP
//
//  Created by Yago Marques on 09/09/22.
//

import Foundation

struct FilmModel: Codable {
    let ghibli: GhibliInfo?
    let tmdb: TmdbResult?
}

struct GhibliInfo: Codable {
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

struct TmdbInfo: Codable {
    let results: [TmdbResult]
}

class TmdbResult: Codable {
    let id: Int
    let title: String
    let overview: String
    let popularity: Double
    let genreIds: [Int]
    var genreNames: [String] = []
    let originalTitle: String
    let backdropPath: String
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? ""
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0
        self.genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds) ?? []
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
    }

    func getGenres() -> String {
        var result = ""

        if genreNames.count == 2 {
            result = "\(genreNames[0]) - \(genreNames[1])"
        } else {
            result = genreNames[0]
        }

        return result
    }

}
