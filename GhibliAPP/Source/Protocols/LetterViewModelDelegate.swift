//
//  LetterViewModelDelegate.swift
//  GhibliAPP
//
//  Created by Yago Marques on 22/09/22.
//

import Foundation

protocol LetterViewModelDelegate: AnyObject {
    func getMoviesToWatch() async -> [FilmModel]?
}
