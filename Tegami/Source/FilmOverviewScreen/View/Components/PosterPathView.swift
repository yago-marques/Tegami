//
//  PosterImageView.swift
//  Tegami
//
//  Created by Stephane Girão Linhares on 29/09/22.
//

import UIKit

final class PosterPathView: UIView {
    
    var film: FilmModel = FilmModel(ghibli: nil, tmdb: nil) {
        didSet {
            DispatchQueue.main.async {
                if let backdropPath = self.film.tmdb?.posterPath {
                    let imageUrl = URL(string: UrlEnum.baseImage.rawValue.appending(backdropPath))!
                    self.posterPath.downloaded(from: imageUrl)
                }
            }
        }
    }
    
    private let posterPath: UIImageView = {
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

extension PosterPathView: ViewCoding {
    func setupView() { }
    
    func setupHierarchy() {
        self.addSubview(posterPath)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            posterPath.topAnchor.constraint(equalTo: self.topAnchor),
            posterPath.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            posterPath.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            posterPath.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
    }
    
}
