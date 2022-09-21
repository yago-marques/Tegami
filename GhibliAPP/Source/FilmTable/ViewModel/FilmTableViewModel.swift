//
//  MainScreenViewModel.swift
//  GhibliAPP
//
//  Created by Yago Marques on 12/09/22.
//

import Foundation

final class FilmTableViewModel {
    weak var delegate: FilmTableViewModelDelegate?
    private let apiService: APICall
    private let defaults = UserDefaults.standard
    var filmsBackup: [FilmModel] = []
    var filmsToSearch = [FilmModel]()

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

    init(apiService: APICall, delegate: FilmTableViewModelDelegate? = nil) {
        self.apiService = apiService
    }

    func createInitialListFilm(films: [FilmModel]) {
        let sortedFilms = films.sorted { $0.tmdb!.popularity > $1.tmdb!.popularity }
        let fiveFilms = sortedFilms[0...4]
        var filmList: [FilmPosition] = []

        for i in 0..<fiveFilms.count {
            let newFilm = FilmPosition(filmId: fiveFilms[i].ghibli!.id, position: i)

            filmList.append(newFilm)
        }

        if let data = try? JSONEncoder().encode(filmList) {
            defaults.set(data, forKey: "filmList")
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
            var genreName = "unknow"
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

}
