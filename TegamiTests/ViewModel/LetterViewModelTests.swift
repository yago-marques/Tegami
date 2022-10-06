//
//  LetterViewModelTests.swift
//  TegamiTests
//
//  Created by Yago Marques on 06/10/22.
//

import XCTest
@testable import Tegami

final class LetterViewModelTests: XCTestCase {
    let mainViewController = MainScreenViewController()
    let mockedDefaults = MockUserDefaults()
    lazy var tableViewModel = FilmTableViewModel(
        apiService: APICall(),
        mainScreenDelegate: self.mainViewController,
        userDefaults: self.mockedDefaults
    )
    lazy var viewModel = LetterViewModel(
        table: self.tableViewModel,
        mainScreenDelegate: self.mainViewController,
        defaults: self.mockedDefaults
    )

    // MARK: fetchNextMovieToWatch method
    func test_fetchNextMovieToWatch_nextFilmNotNil() async {
        await viewModel.fetchNextMovieToWatch()

        XCTAssertNotNil(viewModel.nextFilm.tmdb)
        XCTAssertNotNil(viewModel.nextFilm.ghibli)
    }

    func test_fetchNextMovieToWatchWithTableException_nextFilmNil() async {
        await viewModel.fetchNextMovieToWatch(tableException: true)

        XCTAssertNil(viewModel.nextFilm.tmdb)
        XCTAssertNil(viewModel.nextFilm.ghibli)
    }

    // MARK: getWatchedFilms method
    func test_getWatchedFilmsWithInvalidKey_nil() {
        let watchedFilms = viewModel.getWatchedFilms(watchedKey: "invalid")

        XCTAssertNil(watchedFilms)
    }

    func test_getWatchedFilmsWithDecodeException_nil() {
        let watchedFilms = viewModel.getWatchedFilms(decodeException: true)

        XCTAssertNil(watchedFilms)
    }

    // MARK: updateNextFilm method
    func test_updateNextFilm_filmUpdated() {
        let myFilmModel = FilmModel(
            ghibli:
                GhibliInfo(
                    id: "mock",
                    releaseDate: "mock",
                    runningTime: "mock",
                    originalTitle: "mock"
                ),
            tmdb: nil
        )

        viewModel.updateNextFilm(newFilm: myFilmModel)

        XCTAssertEqual(viewModel.nextFilm.ghibli, myFilmModel.ghibli)
    }
}
