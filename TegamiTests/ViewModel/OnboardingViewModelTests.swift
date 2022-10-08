//
//  OnboardingViewModelTests.swift
//  TegamiTests
//
//  Created by MateuSales on 07/10/22.
//

import XCTest
@testable import Tegami

final class OnboardingVieeModelTests: XCTestCase {
    func test_init_createModelsCorrectly() {
        let (sut, _) = makeSUT()
        
        let results = sut.models
        
        XCTAssertEqual(results[0].title, "")
        XCTAssertEqual(results[0].description, "")
        XCTAssertEqual(results[1].title, "")
        XCTAssertEqual(results[1].description, "")
        XCTAssertEqual(results[2].title, "")
        XCTAssertEqual(results[2].description, "")
    }
}


// MARK: - Helpers

private extension OnboardingVieeModelTests {
    typealias SutAndDoubles = (
        sut: OnboardingViewModel,
        doubles: (
            userDefaultsSpy: UserDefaultsProtocolSpy,
            delegateSpy: OnboardingViewModelDelegateSpy
        )
    )

    func makeSUT() -> SutAndDoubles {
        let userDefaultsSpy = UserDefaultsProtocolSpy()
        let delegateSpy = OnboardingViewModelDelegateSpy()
        let sut = OnboardingViewModel(defaults: userDefaultsSpy)
        sut.delegate = delegateSpy
        
        return (sut, (userDefaultsSpy, delegateSpy))
    }
}

// MARK: - UserDefaultsProtocolSpy

private class UserDefaultsProtocolSpy: UserDefaultsProtocol {
    private(set) var dictionary = [String: Bool]()
    
    func bool(forKey: String) -> Bool {
        dictionary[forKey] ?? false
    }
    
    func setBool(_ value: Bool, forKey: String) {
        dictionary[forKey] = value
    }
}

private class OnboardingViewModelDelegateSpy: OnboardingViewModelDelegate {
    enum Message: Equatable {
        case showOnboarding
        case showMainScreen
        case setup(buttonTitle: String)
        case displayScreen(index: Int)
    }
    
    private(set) var receivedMessages = [Message]()
    
    func showOnboarding() {
        receivedMessages.append(.showOnboarding)
    }
    
    func showMainScreen() {
        receivedMessages.append(.showMainScreen)
    }
    
    func setup(buttonTitle: String) {
        receivedMessages.append(.setup(buttonTitle: buttonTitle))
    }
    
    func displayScreen(at index: Int) {
        receivedMessages.append(.displayScreen(index: index))
    }
}
