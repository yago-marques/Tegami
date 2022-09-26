//
//  ActionSheetDelegate.swift
//  GhibliAPP
//
//  Created by Yago Marques on 25/09/22.
//

import Foundation

protocol ActionSheetDelegate: AnyObject {
    func addNewFilmToList(id: String)
    func removeFilmOfList(id: String)
    func turnFirstOfList(id: String)
}
