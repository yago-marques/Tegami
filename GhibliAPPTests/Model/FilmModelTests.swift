//
//  FilmModel.swift
//  GhibliAPPTests
//
//  Created by Caio Soares on 15/09/22.
//

import XCTest
@testable import GhibliAPP

class FilmModelTests: XCTestCase {
    
    func test_GhibliInfoWhenInfoIsValid_IstanceIsNotNil() {
        
        let testInstance = GhibliInfo(id: "1",
                                      releaseDate: "2000",
                                      runningTime: "120",
                                      originalTitle: "Test Title")
        
        XCTAssertNotNil(testInstance)
        
    }
    
    
    
}
