//
//  FilmOverviewController.swift
//  GhibliAPP
//
//  Created by Gabriela Souza Batista on 22/09/22.
//

import UIKit

final class FilmOverviewController: UIViewController {
    
    private let filmOverView: FilmOverView = {
        let filmOver = FilmOverView()
        filmOver.translatesAutoresizingMaskIntoConstraints = false
        
        return filmOver
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildLayout()
    }

}

extension FilmOverviewController: ViewCoding {
    func setupView() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    func setupHierarchy() {
        view.addSubview(filmOverView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            filmOverView.topAnchor.constraint(equalTo: filmOverView.topAnchor),
            filmOverView.bottomAnchor.constraint(equalTo: filmOverView.bottomAnchor),
            filmOverView.leadingAnchor.constraint(equalTo: filmOverView.leadingAnchor),
            filmOverView.trailingAnchor.constraint(equalTo: filmOverView.trailingAnchor)
        ])
    }
}
