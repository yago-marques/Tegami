//
//  FilmModel.swift
//  GhibliAPP
//
//  Created by Yago Marques on 09/09/22.
//

import Foundation

struct FilmModel: Codable {
    let ghibli: GhibliInfo
    let tmdb: TmdbResult
}
