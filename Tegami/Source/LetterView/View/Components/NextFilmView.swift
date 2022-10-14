//
//  NextFilmView.swift
//  GhibliAPP
//
//  Created by Yago Marques on 22/09/22.
//

import UIKit

final class NextFilmView: UIView {
    
    var film: FilmModel = .init(ghibli: .init(id: "", releaseDate: "", runningTime: "", originalTitle: ""), tmdb: .init()) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = self?.film.tmdb.title
                let imageUrl = URL(string: UrlEnum.baseImage.rawValue.appending((self?.film.tmdb.posterPath)!))!
                self?.filmImageView.downloaded(from: imageUrl)
            }
        }
    }
    
    var labelText: String = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.nextFilmLabel.text = self?.labelText
            }
        }
    }
    
    private let filmImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let infoStack: UIView = {
        let stack = UIView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    private let nextFilmLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NextFilmView: ViewCoding {
    func setupView() {
        
    }
    
    func setupHierarchy() {
        self.addSubview(filmImageView)
        self.addSubview(infoStack)
        infoStack.addSubview(nextFilmLabel)
        infoStack.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            filmImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            filmImageView.widthAnchor.constraint(equalTo: filmImageView.heightAnchor, multiplier: 0.7),
            filmImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            filmImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            infoStack.leadingAnchor.constraint(equalToSystemSpacingAfter: filmImageView.trailingAnchor, multiplier: 1),
            infoStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            infoStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.58),
            
            nextFilmLabel.widthAnchor.constraint(equalTo: infoStack.widthAnchor),
            nextFilmLabel.leadingAnchor.constraint(equalTo: infoStack.leadingAnchor),
            nextFilmLabel.topAnchor.constraint(equalTo: infoStack.topAnchor),
            
            titleLabel.widthAnchor.constraint(equalTo: infoStack.widthAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: infoStack.leadingAnchor),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: nextFilmLabel.bottomAnchor, multiplier: 1)
        ])
    }
}
