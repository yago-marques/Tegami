//
//  PosterImageView.swift
//  Tegami
//
//  Created by Stephane Girão Linhares on 29/09/22.
//

import UIKit

final class PosterImageView: UIView {
    
    var film: FilmModel = FilmModel(ghibli: nil, tmdb: nil) {
        didSet {
            DispatchQueue.main.async {
                if let backdropPath = self.film.tmdb?.posterPath {
                    let imageUrl = URL(string: UrlEnum.baseImage.rawValue.appending(backdropPath))!
                    self.posterImage.downloaded(from: imageUrl)
                }
            }
        }
    }
    
    private let posterImage: UIImageView = {
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

extension PosterImageView: ViewCoding {
    func setupView() { }
    
    func setupHierarchy() {
        self.addSubview(posterImage)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImage.topAnchor.constraint(equalTo: self.topAnchor),
            posterImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            posterImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            posterImage.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
    }
    
}
