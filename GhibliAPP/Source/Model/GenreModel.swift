//
//  GenreModel.swift
//  GhibliAPP
//
//  Created by Yago Marques on 13/09/22.
//

import Foundation

struct GenreModel: Decodable {
    let genres: [GenreInfo]
}

struct GenreInfo: Decodable {
    let name: String
    let id: Int
}
