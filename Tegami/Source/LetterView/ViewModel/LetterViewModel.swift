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
    weak var mainScreenDelegate: MainScreenViewControllerDelegate?
    private var counter: Int = -1
    
    var nextFilm: FilmModel = FilmModel(ghibli: nil, tmdb: nil) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let delegate = self?.delegate, let film = self?.nextFilm {
                    delegate.addFilmToStack(film: film, counter: self?.counter ?? 0)
                }
            }
            counter += 1
        }
    }

    init(
        table: LetterViewModelDelegate,
        delegate: LetterViewControllerDelegate? = nil,
        mainScreenDelegate: MainScreenViewControllerDelegate?
    ) {
        self.mainScreenDelegate = mainScreenDelegate
        self.table = table
    }

    func fetchNextMovieToWatch() async {
        guard let films = await table?.getMoviesToWatch() else { return }
        nextFilm = films.first ?? FilmModel(ghibli: nil, tmdb: nil)
    }

    func getWatchedFilms() -> Double? {
        guard let watchedFilmsData = UserDefaults.standard.object(forKey: "watchedFilms") else { return nil }
        guard let watchedFilms = try? JSONDecoder().decode([FilmPosition].self, from: watchedFilmsData as! Data) else { return nil }

        return Double(watchedFilms.count)
    }
}

extension LetterViewModel: UpdateNextFilmDelegate {
    func updateNextFilm(newFilm: FilmModel) {
        self.nextFilm = newFilm
    }
}
