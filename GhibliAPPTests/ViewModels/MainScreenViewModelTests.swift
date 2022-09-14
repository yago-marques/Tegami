//
//  GhibliAPPTests.swift
//  GhibliAPPTests
//
//  Created by Stephane Girão Linhares on 08/09/22.
//

import XCTest
@testable import GhibliAPP

class MainScreenViewModelTests: XCTestCase {
    
    let viewModel = MainScreenViewModel(apiService: APICall())

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

        let filmResult = await viewModel.fetchFilms()

        XCTAssertNotNil(filmResult)
        XCTAssertEqual(filmResult?.count, filmsTotal)
    }

    func test_fetchFilmsWithRequestExeption_nilResult() async {
        let filmResult = await viewModel.fetchFilms(requestException: true)

        XCTAssertNil(filmResult)
    }

}
