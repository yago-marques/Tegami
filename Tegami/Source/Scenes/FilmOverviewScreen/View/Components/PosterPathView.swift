//
//  PosterImageView.swift
//  Tegami
//
//  Created by Stephane Girão Linhares on 29/09/22.
//

import UIKit

final class PosterPathView: UIView {
    
    var film: Film = .init(id: "", title: "", posterImage: Data(), runningTime: "", releaseDate: "", genre: "", bannerImage: Data(), description: "", popularity: 0.00) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let self = self {
                    self.posterPath.image = UIImage(data: self.film.posterImage)
                }
            }
        }
    }
    
    private let posterPath: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 1
        image.layer.shadowOffset = .zero
        image.layer.shadowRadius = 5
        
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
            posterPath.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 2),
            posterPath.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45),
            posterPath.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.15)
        ])
        
    }
    
}
