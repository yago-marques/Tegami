//
//  MainScreenViewControllerDelegate.swift
//  GhibliAPP
//
//  Created by Yago Marques on 15/09/22.
//

import Foundation

protocol FilmTableViewModelDelegate: AnyObject {
    func reloadTable()
    func isInterective(_ option: Bool)
}
