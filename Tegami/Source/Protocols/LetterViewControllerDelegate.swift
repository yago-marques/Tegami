//
//  LetterViewControllerDelegate.swift
//  GhibliAPP
//
//  Created by Yago Marques on 22/09/22.
//

import Foundation

protocol LetterViewControllerDelegate: AnyObject {
    func addFilmToStack(film: FilmModel, counter: Int)
}
