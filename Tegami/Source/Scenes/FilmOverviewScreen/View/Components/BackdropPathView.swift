//
//  ImageGroupView.swift
//  GhibliAPP
//
//  Created by Stephane Girão Linhares on 26/09/22.
//

import UIKit

final class BackdropPathView: UIView {
    
    var film: Film = .init(id: "", title: "", posterImage: Data(), runningTime: "", releaseDate: "", genre: "", bannerImage: Data(), description: "", popularity: 0.00) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let self {
                    self.backdropPath.image = UIImage(data: self.film.bannerImage)
                }

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
