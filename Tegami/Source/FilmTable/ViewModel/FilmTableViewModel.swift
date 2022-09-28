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
    private let apiService: APICall
    private let defaults = UserDefaults.standard
    var filmsBackup: [FilmModel] = []
    var filmsToSearch = [FilmModel]()
    var tableState: TableState = .all

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
        progressBarDelegate: ProgressBarDelegate? = nil
    ) {
        self.progressBarDelegate = progressBarDelegate
        self.letterDelegate = letterDelegate
        self.apiService = apiService
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
        }
    }

    func fetchFilms(requestException: Bool = false) async {
        guard let ghibliInfo = !requestException ? await self.fetchGhibliInfo() : nil else { return }

        let films: [FilmModel] = await ghibliInfo.asyncMap { ghibliFilm -> FilmModel in
            let tmdbInfo = await fetchTmdbInfo(originalTitle: ghibliFilm.originalTitle)
            let filmInfo = FilmModel(ghibli: ghibliFilm, tmdb: tmdbInfo)
            return filmInfo
        }

        if defaults.object(forKey: "filmList") == nil {
            createInitialListFilm(films: films)
        }

        self.filteredFilms = films
        self.filmsToSearch = films
        self.films = films
    }

    func showAllMovies() {
        let filmsTemp: [FilmModel] = self.films
        self.films = self.filmsBackup
        self.filmsBackup = filmsTemp
        self.tableState = .all
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

    func fetchGhibliInfo(requestException: Bool = false, decoderException: Bool = false) async -> [GhibliInfo]? {
        guard let apiInfo = !requestException ? await apiService.GET(at: UrlEnum.ghibliUrl.rawValue) : nil else {
            return nil
        }

        do {
            let data = !decoderException ? apiInfo.data : Data("decoderException".utf8)
            let ghibliInfo = try JSONDecoder().decode([GhibliInfo].self, from: data)
            return ghibliInfo
        } catch {
            print(error)
            return nil
        }
    }

    func fetchTmdbInfo(
        originalTitle: String,
        requestException: Bool = false,
        decoderException: Bool = false,
        genreException: Bool = false
    ) async -> TmdbResult? {
        guard let apiInfo = !requestException ? await apiService.GET(
            at: UrlEnum.tmbdMovie.rawValue,
            queries: [
                ("api_key", "2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language", "pt-BR"),
                ("query", originalTitle),
                ("page", "1")
            ]
        ) : nil else {
            return nil
        }
        
        do {
            let data = !decoderException ? apiInfo.data : Data("decoderException".utf8)
            let tmdbInfo = try JSONDecoder().decode(TmdbInfo.self, from: data)
            guard let stringGenreList = !genreException ? await transformGenres(
                ids: tmdbInfo.results.first!.genreIds
            ) : nil else {
                return nil
            }
            tmdbInfo.results.first?.genreNames = stringGenreList
            return tmdbInfo.results.first
        } catch {
            print(error)
            return nil
        }
    }

    func fetchGenres(requestException: Bool = false, decoderException: Bool = false ) async -> [GenreInfo]? {
        guard let apiInfo = !requestException ? await apiService.GET(
            at: UrlEnum.tmdbGenre.rawValue,
            queries: [
                ("api_key","2fb0d7c0095f63e9c881bb4317a570a9"),
                ("language","pt-BR")
            ]
        ) : nil else {
            return nil
        }
        do {
            let data = !decoderException ? apiInfo.data : Data("decoderException".utf8)
            let genreInfo = try JSONDecoder().decode(GenreModel.self, from: data)
            return genreInfo.genres
        } catch {
            print(error)
            return nil
        }
    }

    func transformGenres(ids: [Int], requestException: Bool = false) async -> [String]? {
        guard let genreTable = !requestException ? await fetchGenres() : nil else { return nil }
        let idsToTransform: [Int] = ids.count >= 2 ? [ids[0], ids[1]] : [ids[0]]
        
        let genreNames: [String] = idsToTransform.map { id in
            var genreName = "unknown"
            for genre in genreTable where genre.id == id {
                genreName = genre.name
            }
            return genreName
        }

        return genreNames
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
        switch tableState {
        case .all:
            return [
                ("Adicionar na minha lista", "plus.square.on.square.fill"),
                ("Ver detalhes", "info.circle.fill")
            ]
        case .toWatch:
            if !isFirst {
                return [
                    ("Marcar como assistido", "video.fill.badge.checkmark"),
                    ("Tornar o primeiro da lista", "square.3.stack.3d.top.filled"),
                    ("Remover da minha lista", "rectangle.stack.fill.badge.minus"),
                    ("Ver detalhes", "info.circle.fill")
                ]
            } else {
                return [
                    ("Marcar como assistido", "video.fill.badge.checkmark"),
                    ("Remover da minha lista", "rectangle.stack.fill.badge.minus"),
                    ("Ver detalhes", "info.circle.fill")
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

        await self.fetchFilms()
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

        filmList.append(FilmPosition(filmId: id))

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
}
