//
//  ImageGroupView.swift
//  GhibliAPP
//
//  Created by Stephane Girão Linhares on 26/09/22.
//

import UIKit

final class ImageGroupView: UIView {
    
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
        
        return image
    }()
    
//    private let backdropImage: UIImageView = {
//        let image = UIImageView(frame: .zero)
//        image.translatesAutoresizingMaskIntoConstraints = false
//        
//        return image
//    }()
    
    init () {
        super.init(frame: .zero)
        
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageGroupView: ViewCoding {
    func setupView() { }
    
    func setupHierarchy() {
        self.addSubview(backdropImage)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backdropImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            backdropImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backdropImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backdropImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            backdropImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
//            backdropImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.94),
//
//            backdropImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
        
    }
    
}
