//
//  ImageGroupView.swift
//  GhibliAPP
//
//  Created by Stephane Girão Linhares on 26/09/22.
//

import UIKit

final class BackdropPathView: UIView {
    
    var film: FilmModel = FilmModel(ghibli: .init(id: "", releaseDate: "", runningTime: "", originalTitle: ""), tmdb: .init()){
        didSet {
            DispatchQueue.main.async {
                let imageUrl = URL(string: UrlEnum.baseImage.rawValue.appending(self.film.tmdb.backdropPath))!
                self.backdropPath.downloaded(from: imageUrl)
            }
        }
    }
    
    private let backdropPath: UIImageView = {
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

extension BackdropPathView: ViewCoding {
    func setupView() { }
    
    func setupHierarchy() {
        self.addSubview(backdropPath)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backdropPath.topAnchor.constraint(equalTo: self.topAnchor),
            backdropPath.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backdropPath.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            backdropPath.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
    }
    
}
