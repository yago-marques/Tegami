//
//  FilmCardView.swift
//  GhibliAPP
//
//  Created by Yago Marques on 15/09/22.
//

import UIKit

final class FilmCardCell: UITableViewCell {
    
    var film: Film = .init(id: "", title: "", posterImage: Data(), runningTime: "", releaseDate: "", genre: "", bannerImage: Data(), description: "", popularity: 0.00) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let self = self {
                    self.titleLabel.text = self.film.title
                    self.filmImageView.image = UIImage(data: self.film.posterImage)
                    self.runningTimeLabel.text = "\(self.film.runningTime) minutos |"
                    self.releaseDateLabel.text = self.film.releaseDate
                    self.genresLabel.text = self.film.genre
                }
            }
        }
    }
    
    private let cardStack: UIView = {
        let stack = UIView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemGray5
        stack.layer.cornerCurve = .circular
        stack.layer.cornerRadius = 10
        
        return stack
    }()
    
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private let runningTimeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "genero"
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("error FilmCardCell")
    }
    
}

extension FilmCardCell: ViewCoding {
    func setupView() {
        self.backgroundColor = .clear
    }
    
    func setupHierarchy() {
        self.addSubview(cardStack)
        cardStack.addSubview(filmImageView)
        cardStack.addSubview(infoStack)
        infoStack.addSubview(titleLabel)
        infoStack.addSubview(runningTimeLabel)
        infoStack.addSubview(releaseDateLabel)
        infoStack.addSubview(genresLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9),
            cardStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            cardStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cardStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            filmImageView.heightAnchor.constraint(equalTo: cardStack.heightAnchor, multiplier: 0.9),
            filmImageView.widthAnchor.constraint(equalTo: filmImageView.heightAnchor, multiplier: 0.7),
            filmImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            filmImageView.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: cardStack.leadingAnchor, multiplier: 1),
            
            infoStack.leadingAnchor.constraint(equalToSystemSpacingAfter: filmImageView.trailingAnchor, multiplier: 1),
            infoStack.heightAnchor.constraint(equalTo: cardStack.heightAnchor, multiplier: 0.8),
            infoStack.centerYAnchor.constraint(equalTo: cardStack.centerYAnchor),
            infoStack.widthAnchor.constraint(equalTo: cardStack.widthAnchor, multiplier: 0.58),
            
            titleLabel.widthAnchor.constraint(equalTo: infoStack.widthAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: infoStack.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: infoStack.topAnchor),
            
            runningTimeLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 0.5),
            runningTimeLabel.leadingAnchor.constraint(equalTo: infoStack.leadingAnchor),
            
            releaseDateLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 0.5),
            releaseDateLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: runningTimeLabel.trailingAnchor, multiplier: 0.5),
            
            genresLabel.bottomAnchor.constraint(equalTo: infoStack.bottomAnchor),
            genresLabel.leadingAnchor.constraint(equalTo: infoStack.leadingAnchor)
        ])
    }
}
