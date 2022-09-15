//
//  ViewCoding.swift
//  GhibliAPP
//
//  Created by Yago Marques on 15/09/22.
//

import Foundation

protocol ViewCoding {
    func setupView()
    func setupHierarchy()
    func setupConstraints()
}

extension ViewCoding {
    func buildLayout() {
        setupView()
        setupHierarchy()
        setupConstraints()
    }
}
