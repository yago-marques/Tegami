//
//  FilmLoader.swift
//  Tegami
//
//  Created by user on 13/10/22.
//

import Foundation

protocol FilmLoader {
    func getFilms(completion: @escaping (Result<[Film], Error>) -> Void)
}
