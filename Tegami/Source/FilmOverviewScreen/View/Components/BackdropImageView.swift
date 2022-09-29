//
//  ImageGroupView.swift
//  GhibliAPP
//
//  Created by Stephane Girão Linhares on 26/09/22.
//

import UIKit

final class BackdropImageView: UIView {
    
    var film: FilmModel = FilmModel(ghibli: nil, tmdb: nil) {
        didSet {
            DispatchQueue.main.async {
                if let backdropPath = self.film.tmdb?.backdropPath {
                    let imageUrl = URL(string: UrlEnum.baseImage.rawValue.appending(backdropPath))!
                    self.backdropImage.downloaded(from: imageUrl)
                }
            }
        }
    }
    
    private let backdropImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    init () {
        super.init(frame: .zero)
        
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BackdropImageView: ViewCoding {
    func setupView() { }
    
    func setupHierarchy() {
        self.addSubview(backdropImage)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backdropImage.topAnchor.constraint(equalTo: self.topAnchor),
            backdropImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backdropImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            backdropImage.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
    }
    
}
