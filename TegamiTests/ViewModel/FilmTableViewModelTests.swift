//
//  GhibliAPPTests.swift
//  GhibliAPPTests
//
//  Created by Stephane Girão Linhares on 08/09/22.
//

import XCTest
@testable import Tegami

final class FilmTableViewModelTests: XCTestCase {

    let mainScreen = MainScreenViewController()
    let mockedUserDefaults = MockUserDefaults()
    lazy var viewModel = FilmTableViewModel(apiService: APICall(), mainScreenDelegate: self.mainScreen, userDefaults: mockedUserDefaults)

    // MARK: transformGenres method
    func test_transformGenres_ArrayOfString() async {
        
        let givenIds: [Int] = [28, 12, 13, 14, 15] // 28 é ação e 12 e aventura

        let whenTransformGenresResult = await viewModel.transformGenres(ids: givenIds)

        XCTAssertNotNil(whenTransformGenresResult)
        XCTAssertEqual(whenTransformGenresResult?[0], "Ação")
        XCTAssertEqual(whenTransformGenresResult?[1], "Aventura")
    }

    func test_transformGenresWithRequestException_nilResult() async {

        let givenIds: [Int] = [28, 12, 13, 14, 15]

        let whenTransformGenresResult = await viewModel.transformGenres(
            ids: givenIds,
            requestException: true
        )

        XCTAssertNil(whenTransformGenresResult)
    }

    // MARK: fetchGenres method
    func test_fetchGenres_GenreInfoList() async {
        let genresTotal = 19

        let genres = await viewModel.fetchGenres()

        XCTAssertNotNil(genres)
        XCTAssertEqual(genres?.count, genresTotal)
    }

    func test_fetchGenresWithRequestException_nilResult() async {
        let genres = await viewModel.fetchGenres(requestException: true)

        XCTAssertNil(genres)
    }

    func test_fetchGenresWithDecoderException_nilResult() async {
        let genres = await viewModel.fetchGenres(decoderException: true)

        XCTAssertNil(genres)
    }

    // MARK: fetchTmdbInfo method
    func test_fetchTmdbInfo_TmdbResult() async {
        let originalTitle = "崖の上のポニョ"

        let tmdbResult = await viewModel.fetchTmdbInfo(originalTitle: originalTitle)

        XCTAssertNotNil(tmdbResult)
        XCTAssertEqual(tmdbResult?.originalTitle, originalTitle)
    }

    func test_fetchTmdbInfoWithRequestException_nilResult() async {
        let originalTitle = "崖の上のポニョ"

        let tmdbResult = await viewModel.fetchTmdbInfo(
            originalTitle: originalTitle,
            requestException: true
        )

        XCTAssertNil(tmdbResult)
    }

    func test_fetchTmdbInfoWithDecoderException_nilResult() async {
        let originalTitle = "i崖の上のポニョ"

        let tmdbResult = await viewModel.fetchTmdbInfo(
            originalTitle: originalTitle,
            decoderException: true
        )

        XCTAssertNil(tmdbResult)
    }

    func test_fetchTmdbInfoWithGenreException_nilResult() async {
        let originalTitle = "i崖の上のポニョ"

        let tmdbResult = await viewModel.fetchTmdbInfo(
            originalTitle: originalTitle,
            genreException: true
        )

        XCTAssertNil(tmdbResult)
    }

    // MARK: fetchGhibliInfo method
    func test_fetchGhibliInfo_GhibliInfoList() async {
        let ghibliFilmsTotal = 22

        let ghibliResult = await viewModel.fetchGhibliInfo()

        XCTAssertNotNil(ghibliResult)
        XCTAssertEqual(ghibliResult?.count, ghibliFilmsTotal)
    }

    func test_fetchGhibliInfoWithDecoderException_nilResult() async {
        let ghibliResult = await viewModel.fetchGhibliInfo(decoderException: true)

        XCTAssertNil(ghibliResult)
    }

    func test_fetchGhibliInfoWithRequestException_nilResult() async {
        let ghibliResult = await viewModel.fetchGhibliInfo(requestException: true)

        XCTAssertNil(ghibliResult)
    }

    // MARK: fetchFilms method
    func test_fetchFilms_FilmModelList() async {
        let filmsTotal = 22

        await viewModel.fetchFilms()

        XCTAssertNotNil(viewModel.films)
        XCTAssertEqual(viewModel.films.count, filmsTotal)
    }

    func test_fetchFilmsWithRequestExeption_nilResult() async {
        await viewModel.fetchFilms(requestException: true)

        XCTAssertEqual(viewModel.films.count, 0)
    }

    func test_fetchFilmsWithInvalidKey_createInitialListFilm() async {
        await viewModel.fetchFilms(filmKey: "invalid")

        XCTAssertTrue(mockedUserDefaults.setWatchedFilms)
        XCTAssertTrue(mockedUserDefaults.setFilmList)
        XCTAssertEqual(viewModel.films.count, 22)
    }

    // MARK: createInitialListFilm method
    func test_createFilmsOnUserDefaults_validResponse() {
        let mockedFilm = FilmModel(ghibli: GhibliInfo.MockGhibli(id: "mock"), tmdb: TmdbResult.MockTmdb())

        let mockedFilms = [
            mockedFilm, mockedFilm, mockedFilm, mockedFilm, mockedFilm, mockedFilm
        ]

        viewModel.createInitialListFilm(films: mockedFilms)

        XCTAssertTrue(mockedUserDefaults.setFilmList)
        XCTAssertTrue(mockedUserDefaults.setWatchedFilms)
    }

    // MARK: showAllMovies method
    func test_toggleFilmToFilmsToAll_swapFilms() async {
        await viewModel.fetchFilms()
        viewModel.showMoviesToWatch()

        let oldFilms = viewModel.films
        viewModel.showAllMovies()

        XCTAssertEqual(viewModel.filmsBackup.count, oldFilms.count)
        XCTAssertEqual(viewModel.films.count, 22)
        XCTAssertEqual(viewModel.tableState, .all)
    }

    // MARK: showMoviesToWatch method
    func test_toggleFilmToFilmsToWatch_swapFilms() async {
        await viewModel.fetchFilms()
        let currentFilms = viewModel.films

        viewModel.showMoviesToWatch()

        XCTAssertEqual(viewModel.filmsBackup.count, currentFilms.count)
        XCTAssertEqual(viewModel.films.count, 4)
        XCTAssertEqual(viewModel.tableState, .toWatch)
    }

    func test_tryShowFilmsWithoutFilmsOnUserDefaults_noSwapFilms() async {
        await viewModel.fetchFilms()

        viewModel.showMoviesToWatch(filmKey: "invalidReturn")

        XCTAssertEqual(viewModel.filmsBackup.count, 0)
        XCTAssertEqual(viewModel.films.count, 22)
        XCTAssertEqual(viewModel.tableState, .all)
    }

    func test_tryShowFilmsWithDecodeException_noSwapFilms() async {
        await viewModel.fetchFilms()

        viewModel.showMoviesToWatch(decoderException: true)

        XCTAssertEqual(viewModel.filmsBackup.count, 0)
        XCTAssertEqual(viewModel.films.count, 22)
        XCTAssertEqual(viewModel.tableState, .all)
    }

    func test_tryShowFilmsWithInvalidFilmPosition_noSwapFilms() async {
        await viewModel.fetchFilms()

        viewModel.showMoviesToWatch(filmKey: "invalidFilm")

        XCTAssertEqual(viewModel.filmsBackup.count, 22)
        XCTAssertEqual(viewModel.films.count, 1)
        XCTAssertEqual(viewModel.tableState, .toWatch)
        XCTAssertNil(viewModel.films[0].ghibli)
        XCTAssertNil(viewModel.films[0].tmdb)
    }

    // MARK: filterContentForSearchText method
    func test_filterFilm_filteredFilms() async {
        let wordToSearch = "totoro"

        await viewModel.fetchFilms()
        viewModel.filterContentForSearchText(searchText: wordToSearch)

        XCTAssertTrue(!viewModel.filteredFilms.isEmpty)
        XCTAssertTrue(viewModel.filteredFilms.count != 22)
        XCTAssertTrue(viewModel.isSearch)
    }

    func test_filterFilmWithEmptyField_notIsSearch() async {
        let wordToSearch = ""

        await viewModel.fetchFilms()
        viewModel.filterContentForSearchText(searchText: wordToSearch)

        XCTAssertTrue(!viewModel.filteredFilms.isEmpty)
        XCTAssertTrue(viewModel.filteredFilms.count == 22)
        XCTAssertTrue(!viewModel.isSearch)
    }

    // MARK: getActions method
    func test_getSheetActionsToAllFilmsTable_allActions() {
        let actions = viewModel.getActions(state: .all)

        XCTAssertEqual(actions.count, 1)
    }

    func test_getSheetActionsTotoWatchFilmsTable_toWatchActions() {
        let actions = viewModel.getActions(state: .toWatch)

        XCTAssertEqual(actions.count, 3)
    }

    func test_getSheetActionsTotoWatchFilmsTableOnFirstFilm_toWatchActionsWithoutOneOption() {
        let actions = viewModel.getActions(state: .toWatch, isFirst: true)

        XCTAssertEqual(actions.count, 2)
    }

    // MARK: updateFilmsToWatch method
    func test_updateFilmsToWatch_filmsUpdated() async {
        let mockedFilmPositions = FilmPosition.positionMock()

        await viewModel.fetchFilms()
        viewModel.updateFilmsToWatch(filmList: mockedFilmPositions)

        XCTAssertEqual(viewModel.films.count, mockedFilmPositions.count)
    }

    func test_updateFilmsToWatchWithInvalidPosition_filmsUpdated() async {
        let mockedFilmPositions = [FilmPosition(filmId: "mock")]

        await viewModel.fetchFilms()
        viewModel.updateFilmsToWatch(filmList: mockedFilmPositions)

        XCTAssertEqual(viewModel.films.count, mockedFilmPositions.count)
        XCTAssertNil(viewModel.films[0].ghibli)
        XCTAssertNil(viewModel.films[0].tmdb)
    }

    // MARK: getMoviesToWatch method
    func test_getMoviesToWatch_filmList() async {
        let filmsToWatch = await viewModel.getMoviesToWatch()

        XCTAssertNotNil(filmsToWatch)
    }

    // MARK: addNewFilmToList method
    func test_addNewFilmToList_filmAdded() async {
        let position = FilmPosition.newFilmPosition()

        viewModel.addNewFilmToList(id: position.filmId)

        XCTAssertTrue(mockedUserDefaults.setFilmList)
    }

    // MARK: removeFilmOfList method
    func test_removeFilmOfList_filmRemoved() async {
        let position = FilmPosition.positionMock()

        viewModel.removeFilmOfList(id: position[0].filmId)

        XCTAssertTrue(mockedUserDefaults.setFilmList)
    }

    // MARK: turnFirstOfList method
    func test_turnFirstOfList_firstFilm() async {
        let position = FilmPosition.positionMock()

        viewModel.turnFirstOfList(id: position[2].filmId)

        XCTAssertTrue(mockedUserDefaults.setFilmList)
    }

    // MARK: markFilmAsWatched method
    func test_markFilmAsWatched_filmWatched() async {
        let position = FilmPosition.positionMock()

        viewModel.markFilmAsWatched(id: position[2].filmId)

        XCTAssertTrue(mockedUserDefaults.setFilmList)
        XCTAssertTrue(mockedUserDefaults.setWatchedFilms)
    }

    // MARK: findFilmOnList method
    func test_findFilmOnListWithFilmOnList_filmActions() async {
        let position = FilmPosition.positionMock()

        let actions = viewModel.findFilmOnList(id: position[1].filmId)

        XCTAssertNotNil(actions)
        XCTAssertEqual(actions?.count, 3)
    }

    func test_findFilmOnListWithFirstFilmOnList_filmActions() async {
        let position = FilmPosition.positionMock()

        let actions = viewModel.findFilmOnList(id: position[0].filmId)

        XCTAssertNotNil(actions)
        XCTAssertEqual(actions?.count, 2)
    }

    func test_findFilmOnListWithFilmOutsideOfList_filmActions() async {
        let position = FilmPosition.newFilmPosition()

        let actions = viewModel.findFilmOnList(id: position.filmId)

        XCTAssertNotNil(actions)
        XCTAssertEqual(actions?.count, 1)
    }
}
