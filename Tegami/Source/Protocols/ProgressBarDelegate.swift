//
//  ProgressBarDelegate.swift
//  GhibliAPP
//
//  Created by Yago Marques on 26/09/22.
//

import Foundation

protocol ProgressBarDelegate: AnyObject {
    func updateBar(watchedFilms: Double)
}
