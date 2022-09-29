//
//  DescriptionView.swift
//  GhibliAPP
//
//  Created by Stephane Girão Linhares on 26/09/22.
//

import UIKit

final class DescriptionFilmView: UIView {
    
    var filmTeste: FilmModel = FilmModel(ghibli: nil, tmdb: nil) {
        didSet {
            DispatchQueue.main.async {
                self.titleLabel.text = self.filmTeste.tmdb?.title
               // self.runningTimeLabel.text = self.filmTeste.ghibli?.runningTime
                self.releaseDateLabel.text = self.filmTeste.ghibli?.releaseDate
                self.overviewLabel.text = self.filmTeste.tmdb?.overview
                self.runningTimeLabel.text = "\(self.filmTeste.ghibli?.runningTime ?? "--") minutos, "
            }
        }
    }
    
    private let cardView: UIView = {
        let card = UIView(frame: .zero)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor(named: "cSky")
        
        return card
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel(frame: .zero)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        return title
    }()
    
    private let runningTimeLabel: UILabel = {
        let duration = UILabel(frame: .zero)
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.numberOfLines = 0
        duration.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        return duration
    }()
    
    private let releaseDateLabel: UILabel = {
        let date = UILabel(frame: .zero)
        date.translatesAutoresizingMaskIntoConstraints = false
        date.numberOfLines = 0
        date.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        return date
    }()

    private lazy var overviewLabel: UITextView = {
        let overview = UITextView(frame: .zero)
        overview.isScrollEnabled = true
        overview.isUserInteractionEnabled = true
        overview.translatesAutoresizingMaskIntoConstraints = false
        overview.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        overview.backgroundColor = .clear
        
        return overview
    }()
    
    init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DescriptionFilmView: ViewCoding {
    func setupView() { }
    
    func setupHierarchy() {
        self.addSubview(cardView)
        self.addSubview(titleLabel)
        self.addSubview(runningTimeLabel)
        self.addSubview(releaseDateLabel)
        self.addSubview(overviewLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            cardView.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            cardView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            cardView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45),
            cardView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            cardView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: cardView.topAnchor, multiplier: 8),
            titleLabel.bottomAnchor.constraint(equalTo: runningTimeLabel.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),

            runningTimeLabel.topAnchor.constraint(equalTo: releaseDateLabel.topAnchor),
            runningTimeLabel.bottomAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor),
            runningTimeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            runningTimeLabel.trailingAnchor.constraint(equalTo: releaseDateLabel.leadingAnchor),
            
            releaseDateLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.topAnchor, multiplier: 7),
//            releaseDateLabel.bottomAnchor.constraint(equalTo: overviewLabel.topAnchor),
            releaseDateLabel.leadingAnchor.constraint(equalTo: runningTimeLabel.trailingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            overviewLabel.topAnchor.constraint(equalToSystemSpacingBelow: releaseDateLabel.topAnchor, multiplier: 5),
//            overviewLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            overviewLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            overviewLabel.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.5)
        ])
    }
}
