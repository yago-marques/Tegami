//
//  FilmOverviewController.swift
//  GhibliAPP
//
//  Created by Gabriela Souza Batista on 22/09/22.
//
import UIKit

final class FilmOverviewController: UIViewController {
    
    private var film: FilmModel
    
    init(film: FilmModel) {
        self.film = film
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundView: BackgroundView = {
        let background = BackgroundView()
        background.translatesAutoresizingMaskIntoConstraints = false
        
        return background
    }()
    
    private lazy var backdropPathView : BackdropPathView = {
        let image = BackdropPathView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.film = self.film
        
        return image
    }()
    
    private lazy var posterPathView : PosterPathView = {
        let imagePoster = PosterPathView()
        imagePoster.translatesAutoresizingMaskIntoConstraints = false
        imagePoster.film = self.film
        
        return imagePoster
    }()
    
    private lazy var descriptionFilmView : DescriptionFilmView = {
        let description = DescriptionFilmView()
        description.translatesAutoresizingMaskIntoConstraints = false
//        description.backgroundColor = .white
        description.filmTeste = self.film

        return description
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildLayout()
    }

}

extension FilmOverviewController: ViewCoding {
    func setupView() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = false
        UINavigationBar.appearance().tintColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(descriptionFilmView)
//        view.addSubview(posterPathView)
        view.addSubview(backdropPathView)
        
        view.sendSubviewToBack(backgroundView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            descriptionFilmView.topAnchor.constraint(equalTo: view.topAnchor),
            descriptionFilmView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            descriptionFilmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionFilmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backdropPathView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backdropPathView.widthAnchor.constraint(equalTo: view.widthAnchor),
            backdropPathView.heightAnchor.constraint(equalTo: backdropPathView.widthAnchor, multiplier: 0.5),
            
//            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 0.5)
        ])
    }
}
