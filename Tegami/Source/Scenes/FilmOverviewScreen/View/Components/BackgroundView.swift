//
//  FilmOverView.swift
//  GhibliAPP
//
//  Created by Gabriela Souza Batista on 22/09/22.
//

import UIKit

final class BackgroundView: UIView {

    private lazy var backgroundOverview: UIImageView = {
        self.makeBackground(name: "SceneOverview", contentMode: .scaleAspectFill)
    }()
    
    init () {
        super.init(frame: .zero)
        
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BackgroundView {
    
    func makeBackground(name: String, contentMode: UIView.ContentMode) -> UIImageView {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: name)
        image.contentMode = contentMode
        return image
    }
    
}

extension BackgroundView: ViewCoding {
    func setupView() { }
    
    func setupHierarchy() {
        self.addSubview(backgroundOverview)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundOverview.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundOverview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundOverview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundOverview.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
        
}
