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
    
    func test_GhibliInfoWhenInfoIsValid_InstanceIsNotNil() {
        
        let testInstance = GhibliInfo(id: "1",
                                      releaseDate: "2000",
                                      runningTime: "120",
                                      originalTitle: "Test Title")
        
        XCTAssertNotNil(testInstance)
        
    }
    
    func test_TmdbResultWhenInputJSONStringIsInvalid_InstanceIsNotNil() {
        // given
        let jsonString =    """
                            {
                                "invalidKey": 1
                            }
                            """
        let data = jsonString.data(using: .utf8)!

        // when // XCTUnwrap
        let testInstance = try? JSONDecoder().decode(
            TmdbResult.self,
            from: data
        )
        
        // then
        XCTAssertNotNil(testInstance)
        
        /*  Como o init da TmdbResult espera um JSON, vindo a partir do Decoder, a gente tem que passar um JSON pro init.
            No caso desse test, a gente usou um JSON inválido pra forçar o init a usar valores padrões.
            Encodamos o JSON utilizando uft8 em uma variável chamada data.
            Criamos a instancia de test tentando decodar o JSON e atribuindo o valor dele para TmdbResult.self a partir da variável data.
            No final só confirmamos que a instancia de test criada não é nula, já que se o JSON é inválido, ele iria recorrer aos valores padrões.         */
        
    }
    
    func test_FilmModelWhenBothAreValid_FilmModelIsNotNil() {
        
        let ghibliInstance = GhibliInfo(id: "1",
                                        releaseDate: "2000",
                                        runningTime: "120",
                                        originalTitle: "Test Title")
        
        let tmdbJSONString =    """
                            {
                                "invalidKey": 1
                            }
                            """
        let data = tmdbJSONString.data(using: .utf8)!
        let tmdbInstance = try? JSONDecoder().decode(
            TmdbResult.self,
            from: data
        )
        
        let filmModelInstance = FilmModel.init(ghibli: ghibliInstance,
                                               tmdb: tmdbInstance)
        
        XCTAssertNotNil(filmModelInstance)
        
    }
    
}
