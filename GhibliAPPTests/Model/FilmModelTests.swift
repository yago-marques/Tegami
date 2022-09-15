//
//  FilmModel.swift
//  GhibliAPPTests
//
//  Created by Caio Soares on 15/09/22.
//

import XCTest
@testable import GhibliAPP

final class FilmModelTests: XCTestCase {
    
    func test_tmdbInfoInit_tmdbResultArray() {
        let emptyArray: [TmdbResult] = []
        let tmdbStruct = TmdbInfo(results: emptyArray)
        
        XCTAssertEqual(tmdbStruct.results.count, emptyArray.count)
        
    }
    
    func test_tmdbResultInit_validTmdbResult() {
        let id: Int = 123
        let title: String = "Piratas do caribi"
        let overview: String = "Um Belo filme"
        let popularity: Double = 12.345
        let genreIdsGiven: [Int] = [12, 13, 15]
        let genreNamesGiven: [String] = ["Ação", "Piratas"]
        let originalTitle: String = "piratas"
        let backdropPath: String = "/hgfhvFVKF.jpg"
        let posterPath: String = "/jbfjbjbfjje.jpg"
        
        let myFilm = TmdbResult(
            id: id,
            title: title,
            overview: overview,
            popularity: popularity,
            genreIds: genreIdsGiven,
            genreNames: genreNamesGiven,
            originalTitle: originalTitle,
            backdropPath: backdropPath,
            posterPath: posterPath
        )
        
        XCTAssertEqual(myFilm.id, id)
        XCTAssertEqual(myFilm.title, title)
        XCTAssertEqual(myFilm.overview, overview)
        XCTAssertEqual(myFilm.popularity, 12.345)
        XCTAssertEqual(myFilm.genreIds, genreIdsGiven)
        XCTAssertEqual(myFilm.genreNames, genreNamesGiven)
        XCTAssertEqual(myFilm.originalTitle, originalTitle)
        XCTAssertEqual(myFilm.backdropPath, backdropPath)
        XCTAssertEqual(myFilm.posterPath, posterPath)
    }
    
    func test_GhibliInfoWhenInfoIsValid_IstanceIsNotNil() {
        
        let testInstance = GhibliInfo(id: "1",
                                      releaseDate: "2000",
                                      runningTime: "120",
                                      originalTitle: "Test Title")
        
        XCTAssertNotNil(testInstance)
        
    }
    
}
