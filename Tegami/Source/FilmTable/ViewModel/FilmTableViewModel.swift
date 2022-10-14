//
//  MainScreenViewModel.swift
//  GhibliAPP
//
//  Created by Yago Marques on 12/09/22.
//

import Foundation

final class FilmTableViewModel {
    weak var letterDelegate: UpdateNextFilmDelegate?
    weak var progressBarDelegate: ProgressBarDelegate?
    weak var delegate: FilmTableViewModelDelegate?
    weak var mainScreenDelegate: MainScreenViewControllerDelegate?
    var firstWillAppear: Bool = true
    var filmsBackup: [FilmModel] = []
    var filmsToSearch = [FilmModel]()
    var tableState: TableState = .all
    var TableIsEmpty: Bool = false
    var loadingFilms: Bool = false
    private let defaults: UserDefaults
    private let loader: FilmLoader

    var isSearch: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.reloadTable()
            }
        }
    }

    var films: [FilmModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.reloadTable()
            }
        }
    }

    var filteredFilms = [FilmModel]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.reloadTable()
            }
        }
    }

    init(
        delegate: FilmTableViewModelDelegate? = nil,
        letterDelegate: UpdateNextFilmDelegate? = nil,
        progressBarDelegate: ProgressBarDelegate? = nil,
        mainScreenDelegate: MainScreenViewControllerDelegate?,
        userDefaults: UserDefaults,
        loader: FilmLoader
    ) {
        self.mainScreenDelegate = mainScreenDelegate
        self.progressBarDelegate = progressBarDelegate
        self.letterDelegate = letterDelegate
        self.defaults = userDefaults
        self.loader = loader
    }

    func createInitialListFilm(films: [FilmModel]) {
        let sortedFilms = films.sorted { $0.tmdb.popularity > $1.tmdb.popularity }
        let fiveFilms = sortedFilms[0...4]
        var filmList: [FilmPosition] = []
        let watchedFilms: [FilmPosition] = []

        for i in 0..<fiveFilms.count {
            let newFilm = FilmPosition(filmId: fiveFilms[i].ghibli.id)

            filmList.append(newFilm)
        }

        if
            let listData = try? JSONEncoder().encode(filmList),
            let watchedData = try? JSONEncoder().encode(watchedFilms)
        {
            defaults.set(listData, forKey: "filmList")
            defaults.set(watchedData, forKey: "watchedFilms")

            letterDelegate?.updateNextFilm(newFilm: fiveFilms[0])
        }
    }

    func fetchFilms() {
        loader.getFilms { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }

    func showAllMovies() {
        self.TableIsEmpty = false
        let filmsTemp: [FilmModel] = self.films
        self.films = self.filmsBackup
        self.filmsBackup = filmsTemp
        self.tableState = .all
        self.loadingFilms = false
    }

    func showMoviesToWatch() {
        guard let data = defaults.object(forKey: "filmList") else { return }
        guard let filmList = try? JSONDecoder().decode([FilmPosition].self, from: data as! Data) else { return }

        let filmsToWatch = filmList.map { position -> FilmModel in
            let filmOfPosition = self.films.first { $0.ghibli.id == position.filmId }

            return filmOfPosition ?? makeFilmModel()
        }

        self.filmsBackup = self.films
        self.films = filmsToWatch
        self.tableState = .toWatch
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText.isEmpty {
            self.isSearch = false
        } else {
            self.isSearch = true
            self.filteredFilms = self.filmsToSearch.filter { film in
                return film.tmdb.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func getActions(state: TableState, isFirst: Bool = false) -> [(String, String)] {
        switch state {
        case .all:
            return [
                ("Adicionar na minha lista", "plus.square.on.square.fill")
            ]
        case .toWatch:
            if !isFirst {
                return [
                    ("Marcar como assistido", "video.fill.badge.checkmark"),
                    ("Tornar o primeiro da lista", "square.3.stack.3d.top.filled"),
                    ("Remover da minha lista", "rectangle.stack.fill.badge.minus")
                ]
            } else {
                return [
                    ("Marcar como assistido", "video.fill.badge.checkmark"),
                    ("Remover da minha lista", "rectangle.stack.fill.badge.minus")
                ]
            }
        }
    }

    func updateFilmsToWatch(filmList: [FilmPosition]) {
        if let dataToStore = try? JSONEncoder().encode(filmList) {
            defaults.set(dataToStore, forKey: "filmList")

            let filmsToWatch = filmList.map { position -> FilmModel in
                let filmOfPosition = self.films.first { $0.ghibli.id == position.filmId }

                return filmOfPosition ?? makeFilmModel()
            }

            self.films = filmsToWatch
        }
    }
}

extension FilmTableViewModel: LetterViewModelDelegate {
    func getMoviesToWatch() async -> [FilmModel]? {
        guard let data = defaults.object(forKey: "filmList") else { return nil }
        guard let filmList = try? JSONDecoder().decode([FilmPosition].self, from: data as! Data) else { return nil }

        let filmsToWatch = filmList.map { position -> FilmModel in
            let filmOfPosition = self.films.first { $0.ghibli.id == position.filmId }

            return filmOfPosition ?? makeFilmModel()
        }

        return filmsToWatch
    }
}

extension FilmTableViewModel: ActionSheetDelegate {
    func addNewFilmToList(id: String) {
        guard let data = defaults.object(forKey: "filmList") else { return }
        guard var filmList = try? JSONDecoder().decode([FilmPosition].self, from: data as! Data) else { return }

        if filmList.firstIndex(of: FilmPosition(filmId: id)) == nil {
            filmList.append(FilmPosition(filmId: id))
        }

        let filmsToWatch = filmList.map { position -> FilmModel in
            let filmOfPosition = self.films.first { $0.ghibli.id == position.filmId }

            return filmOfPosition ?? makeFilmModel()
        }

        if let dataToStore = try? JSONEncoder().encode(filmList) {
            defaults.set(dataToStore, forKey: "filmList")
        }

        self.letterDelegate?.updateNextFilm(newFilm: filmsToWatch[0])

    }

    func removeFilmOfList(id: String) {
        guard let data = defaults.object(forKey: "filmList") else { return }
        guard var filmList = try? JSONDecoder().decode([FilmPosition].self, from: data as! Data) else { return }

        if let index = filmList.firstIndex(of: FilmPosition(filmId: id)) {
            filmList.remove(at: index)
        }

        self.updateFilmsToWatch(filmList: filmList)

        self.letterDelegate?.updateNextFilm(newFilm: !self.films.isEmpty ? self.films[0] : makeFilmModel())
    }

    func turnFirstOfList(id: String) {
        guard let data = defaults.object(forKey: "filmList") else { return }
        guard var filmList = try? JSONDecoder().decode([FilmPosition].self, from: data as! Data) else { return }

        if let index = filmList.firstIndex(of: FilmPosition(filmId: id)) {
            filmList.move(filmList[index], to: 0)
        }

        self.updateFilmsToWatch(filmList: filmList)

        self.letterDelegate?.updateNextFilm(newFilm: self.films[0])
    }

    func markFilmAsWatched(id: String) {
        guard let watchedFilmsData = defaults.object(forKey: "watchedFilms") else { return }
        guard var watchedFilms = try? JSONDecoder().decode([FilmPosition].self, from: watchedFilmsData as! Data) else { return }

        if watchedFilms.firstIndex(of: FilmPosition(filmId: id)) == nil {
            watchedFilms.append(FilmPosition(filmId: id))
        }

        if let dataToStore = try? JSONEncoder().encode(watchedFilms) {
            defaults.set(dataToStore, forKey: "watchedFilms")
        }

        self.removeFilmOfList(id: id)

        self.progressBarDelegate?.updateBar(watchedFilms: Double(watchedFilms.count))
    }

    func findFilmOnList(id: String) -> [(String, String)]? {
        guard let data = defaults.object(forKey: "filmList") else { return nil }
        guard let filmList = try? JSONDecoder().decode([FilmPosition].self, from: data as! Data) else { return nil }

        if let index = filmList.firstIndex(of: FilmPosition(filmId: id)) {
            if index == 0 {
                return self.getActions(state: .toWatch, isFirst: true)
            } else {
                return self.getActions(state: .toWatch)
            }
        } else {
            return self.getActions(state: .all)
        }
    }
    
    func makeFilmModel() -> FilmModel {
        FilmModel(ghibli: .init(id: "", releaseDate: "", runningTime: "", originalTitle: ""), tmdb: .init())
    }
}

extension FilmTableViewModel {
    func toggleViewInterective(to state: Bool) {
        delegate?.isInterective(state)
    }
}
