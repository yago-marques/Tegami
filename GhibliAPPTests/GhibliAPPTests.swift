//
//  GhibliAPPTests.swift
//  GhibliAPPTests
//
//  Created by Stephane Girão Linhares on 08/09/22.
//

//estrutura base:
//given
//when
//then

import XCTest
@testable import GhibliAPP

class MainScreenViewModelTests: XCTestCase {
    
    //viewModel que será usado em todos os tests
    let viewModel = MainScreenViewModel(apiService: APICall())
    
    func test_transformGenresWithLongList_ArrayString() async {
        //given
        //precisamos dos IDs.
        
        let givenIds: [Int] = [28, 12, 13, 14, 15] // 28 é ação e 12 e aventura
        
        //when
        let whenTransformGenresResult = await viewModel.transformGenres(ids: givenIds) ?? ["",""]
        
        //then
        XCTAssertEqual(whenTransformGenresResult[0], "Ação")
        XCTAssertEqual(whenTransformGenresResult[1], "Aventura")
        
    }

}
