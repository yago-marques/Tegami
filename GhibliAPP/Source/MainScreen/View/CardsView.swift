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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(filmPoster)
        addSubview(filmTitle)
        addSubview(filmDescription)
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
    
    func constrainsPoster() {
        filmPoster.translatesAutoresizingMaskIntoConstraints = false
        filmPoster.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
