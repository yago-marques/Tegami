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
    private let apiService: APICall
    private let defaults: UserDefaults
    var firstWillAppear: Bool = true
    var filmsBackup: [FilmModel] = []
    var filmsToSearch = [FilmModel]()
    var tableState: TableState = .all
    var TableIsEmpty: Bool = false
    var loadingFilms: Bool = false

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
        apiService: APICall,
        delegate: FilmTableViewModelDelegate? = nil,
        letterDelegate: UpdateNextFilmDelegate? = nil,
        progressBarDelegate: ProgressBarDelegate? = nil,
        mainScreenDelegate: MainScreenViewControllerDelegate?,
        userDefaults: UserDefaults
    ) {
        self.mainScreenDelegate = mainScreenDelegate
        self.progressBarDelegate = progressBarDelegate
        self.letterDelegate = letterDelegate
        self.apiService = apiService
        self.defaults = userDefaults
    }

    func createInitialListFilm(films: [FilmModel]) {
        let sortedFilms = films.sorted { $0.tmdb!.popularity > $1.tmdb!.popularity }
        let fiveFilms = sortedFilms[0...4]
        var filmList: [FilmPosition] = []
        let watchedFilms: [FilmPosition] = []

        for i in 0..<fiveFilms.count {
            let newFilm = FilmPosition(filmId: fiveFilms[i].ghibli!.id)

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
        self.fetchGhibliInfo { [weak self] result in
            if let self = self {
                switch result {
                case .success(let ghibliInfo):
                    var films: [FilmModel] = []

                    for i in 0..<ghibliInfo.count {
                        self.fetchTmdbInfo(originalTitle: ghibliInfo[i].originalTitle) { result in
                            switch result {
                            case .success(let tmdbInfo):
                                let filmInfo = FilmModel(ghibli: ghibliInfo[i], tmdb: tmdbInfo)
                                films.append(filmInfo)

                                if films.count == 22 {
                                    if self.defaults.object(forKey: "filmList") == nil {
                                        self.createInitialListFilm(films: films)
                                    }

                                    self.filteredFilms = films
                                    self.filmsToSearch = films
                                    self.films = films
                                    self.loadingFilms = false
                                    self.firstWillAppear = false
                                }
                            case .failure(let failure):
                                print(failure)
                            }
                        }
                    }

                case .failure(let failure):
                    print(failure)
                }
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
            let filmOfPosition = self.films.first { $0.ghibli?.id == position.filmId }

            return filmOfPosition ?? FilmModel(ghibli: nil, tmdb: nil)
        }

        self.filmsBackup = self.films
        self.films = filmsToWatch
        self.tableState = .toWatch
    }

    func fetchGhibliInfo(completion: @escaping (Result<[GhibliInfo], Error>) -> Void) {
        delegate?.isInterective(false)

        apiService.GET(at: UrlEnum.ghibliUrl.rawValue) { [weak self] result in
            if let self = self {
                switch result {
                case .success(let (data, _)):
                    do {
                        let ghibliInfo = try JSONDecoder().decode([GhibliInfo].self, from: data)
                        self.delegate?.isInterective(true)
                        completion(.success(ghibliInfo))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }

    func fetchTmdbInfo(
        originalTitle: String,
        completion: @escaping (Result<TmdbResult?, Error>) -> Void
    ) {

        apiService.GET(
            at: UrlEnum.tmbdMovie.rawValue,
            queries: [
                ("api_key", "2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language", "pt-BR"),
                ("query", originalTitle),
                ("page", "1")
            ]
        ) { [weak self] result in
            if let self = self {
                switch result {
                case .success(let (data, _)):
                    do {
                        let tmdbInfo = try JSONDecoder().decode(TmdbInfo.self, from: data)
                        self.transformGenres(ids: tmdbInfo.results.first!.genreIds) { genreResult in
                            switch genreResult {
                            case .success(let stringGenreList):
                                tmdbInfo.results.first?.genreNames = stringGenreList
                                completion(.success(tmdbInfo.results.first))
                            case .failure(let failure):
                                completion(.failure(failure))
                            }
                        }

                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
    }

    func fetchGenres(completion: @escaping (Result<[GenreInfo], Error>) -> Void) {

        apiService.GET(
            at: UrlEnum.tmdbGenre.rawValue,
            queries: [
                ("api_key","2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language","pt-BR")
            ]
        ) { result in
            switch result {
            case .success(let (data, _)):
                do {
                    let genreInfo = try JSONDecoder().decode(GenreModel.self, from: data)
                    completion(.success(genreInfo.genres))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }

    }

    func transformGenres(
        ids: [Int],
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        self.fetchGenres { result in
            switch result {
            case .success(let genreTable):
                let idsToTransform: [Int] = ids.count >= 2 ? [ids[0], ids[1]] : [ids[0]]

                let genreNames: [String] = idsToTransform.map { id in
                    var genreName = "unknown"
                    for genre in genreTable where genre.id == id {
                        genreName = genre.name
                    }
                    return genreName
                }

                completion(.success(genreNames))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }

    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText.isEmpty {
            self.isSearch = false
        } else {
            self.isSearch = true
            self.filteredFilms = self.filmsToSearch.filter { film in
                return film.tmdb!.title.lowercased().contains(searchText.lowercased())
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
                let filmOfPosition = self.films.first { $0.ghibli?.id == position.filmId }

                return filmOfPosition ?? FilmModel(ghibli: nil, tmdb: nil)
            }

            self.films = filmsToWatch
        }
    }
}

extension FilmTableViewModel: LetterViewModelDelegate {
    func getMoviesToWatch() async -> [FilmModel]? {
        guard let data = defaults.object(forKey: "filmList") else { return nil }
        guard let filmList = try? JSONDecoder().decode([FilmPosition].self, from: data as! Data) else { return nil }

        self.fetchFilms()
        let filmsToWatch = filmList.map { position -> FilmModel in
            let filmOfPosition = self.films.first { $0.ghibli?.id == position.filmId }

            return filmOfPosition ?? FilmModel(ghibli: nil, tmdb: nil)
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
            let filmOfPosition = self.films.first { $0.ghibli?.id == position.filmId }

            return filmOfPosition ?? FilmModel(ghibli: nil, tmdb: nil)
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

        self.letterDelegate?.updateNextFilm(newFilm: !self.films.isEmpty ? self.films[0] : FilmModel(ghibli: nil, tmdb: nil))
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
}
