//
//  LetterViewModel.swift
//  GhibliAPP
//
//  Created by Yago Marques on 22/09/22.
//

import Foundation

final class LetterViewModel {

    private let table: LetterViewModelDelegate?
    weak var delegate: LetterViewControllerDelegate?
    
    var nextFilm: FilmModel = FilmModel(ghibli: nil, tmdb: nil) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let delegate = self?.delegate, let film = self?.nextFilm {
                    delegate.addFilmToStack(film: film)
                }
            }
        }
    }

    init(
        table: LetterViewModelDelegate,
        delegate: LetterViewControllerDelegate? = nil
    ) {
        self.table = table
    }

    func fetchNextMovieToWatch() async {
        guard let films = await table?.getMoviesToWatch() else { return }
        nextFilm = films.first ?? FilmModel(ghibli: nil, tmdb: nil)
    }
}
