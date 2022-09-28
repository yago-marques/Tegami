//
//  FilmTableHeader.swift
//  GhibliAPP
//
//  Created by Yago Marques on 19/09/22.
//

import UIKit

final class FilmTableHeader: UIView {

    weak var delegate: FilmTableHeaderDelegate?

    private lazy var filmSegmentedControl: UIView = {
        let control = UISegmentedControl(items: ["Todos os filmes", "Minha lista"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(swapTable), for: .valueChanged)

        return control
    }()

    init(delegate: FilmTableHeaderDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilmTableHeader {
    @objc func swapTable(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 1:
            delegate?.moviesToWatch()
        case 0:
            delegate?.allFilms()
        default:
            print("error")
        }
    }
}

extension FilmTableHeader: ViewCoding {
    func setupView() { }

    func setupHierarchy() {
        self.addSubview(filmSegmentedControl)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            filmSegmentedControl.topAnchor.constraint(equalTo: self.topAnchor),
            filmSegmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        
            filmSegmentedControl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9)
        ])
    }
}
