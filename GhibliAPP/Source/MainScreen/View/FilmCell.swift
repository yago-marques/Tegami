//
//  CardsView.swift
//  GhibliAPP
//
//  Created by Stephane Girão Linhares on 16/09/22.
//

import UIKit

class FilmCell: UITableViewCell {
    
    var filmPoster = UIImageView()
    var filmTitle = UILabel()
    var filmDescription = UILabel()
    
    var mockImageName = "MockPoster.png"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        filmTitle.text = "Hello World"
        
        
        addSubview(filmPoster)
        addSubview(filmTitle)
        addSubview(filmDescription)
        
        configureFilmPost()
        configureFilmTitle()
        configureFilmDescription()
        
        constraintsFilmPoster()
        constraintsFilmTitle()
        
    }
    
    func configureFilmPost() {
        filmPoster.layer.cornerRadius = 5
        filmPoster.clipsToBounds = true
    }
    
    func configureFilmTitle() {
        filmTitle.numberOfLines = 0
        filmTitle.adjustsFontSizeToFitWidth = true
        filmTitle.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func configureFilmDescription() {
        filmDescription.numberOfLines = 0
        filmDescription.adjustsFontSizeToFitWidth = true
        filmDescription.font = UIFont.systemFont(ofSize: 17)
    }
    
    func constraintsFilmPoster() {
        filmPoster.translatesAutoresizingMaskIntoConstraints                                            = false
        filmPoster.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                            = true
        filmPoster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive              = true
        filmPoster.heightAnchor.constraint(equalToConstant: 80).isActive                                = true
        filmPoster.widthAnchor.constraint(equalTo: filmPoster.heightAnchor, multiplier: 2/3).isActive   = true
    }
    
    func constraintsFilmTitle() {
        filmTitle.translatesAutoresizingMaskIntoConstraints                                             = false
        filmTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                             = true
        filmTitle.leadingAnchor.constraint(equalTo: filmPoster.trailingAnchor, constant: 20).isActive   = true
        filmTitle.heightAnchor.constraint(equalToConstant: 80).isActive                                 = true
        filmTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive            = true
    }
    
    func constraintsFilmDescription() {
        filmDescription.translatesAutoresizingMaskIntoConstraints                                             = false
        filmDescription.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                             = true
        filmDescription.leadingAnchor.constraint(equalTo: filmPoster.trailingAnchor, constant: 20).isActive   = true
        filmDescription.heightAnchor.constraint(equalToConstant: -80).isActive                                 = true
        filmDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive            = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
