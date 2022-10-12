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
        
        XCTAssertEqual(results[0].title, "Explore o vasto universo das animações do Studio Ghibli")
        XCTAssertEqual(results[0].description, "")
        XCTAssertEqual(results[1].title, "Barra de XP")
        XCTAssertEqual(results[1].description, "Maratone os filmes do Studio Ghibli e faça sua barra de XP crescer!! não esqueça de compartilhar sua evolução com os amigos")
        XCTAssertEqual(results[2].title, "Sua lista de filmes")
        XCTAssertEqual(results[2].description, "Procuramos os cinco filmes mais populares do Studio Ghibli e adicionamos à sua lista de filmes :)")
    }
    
    func test_getModel_shouldReturnCorrectModel() {
        let (sut, _) = makeSUT()
        
        let model = sut.getModel(at: 0)
        
        XCTAssertEqual(model.title, "Explore o vasto universo das animações do Studio Ghibli")
        XCTAssertEqual(model.description, "")
    }
    
    func test_numberOfItems_shouldReturnThree() {
        let (sut, _) = makeSUT()
        
        let numberOfItems = sut.numberOfItems()
        
        XCTAssertEqual(numberOfItems, 3)
    }
    
    func test_presentOnboardingIfNeeded_whenKeyOnboardIsTrue_shouldShowMainScreen() {
        let (sut, doubles) = makeSUT()
        doubles.userDefaultsStub.setBool(true, forKey: "onboard")
        
        sut.presentOnboardingIfNeeded()
        
        XCTAssertEqual(doubles.delegateSpy.receivedMessages, [.showMainScreen])
    }
    
    func test_presentOnboardingIfNeeded_whenKeyOnboardIsFalse_shouldShowOnboarding() {
        let (sut, doubles) = makeSUT()
        doubles.userDefaultsStub.setBool(false, forKey: "onboard")
        
        sut.presentOnboardingIfNeeded()
        
        XCTAssertEqual(doubles.delegateSpy.receivedMessages, [.showOnboarding])
    }
    
    func test_setupTitle_whenIndexIsTwo_shouldSetupStartTitle() {
        let (sut, doubles) = makeSUT()
        
        sut.setupTitle(at: 2)
        
        XCTAssertEqual(doubles.delegateSpy.receivedMessages, [.setup(buttonTitle: "Quero começar")])
    }
    
    func test_setupTitle_whenIndexIsNotTwo_shouldSetupNextTitle() {
        let (sut, doubles) = makeSUT()
        
        sut.setupTitle(at: Int.random(in: 0...1))
        
        XCTAssertEqual(doubles.delegateSpy.receivedMessages, [.setup(buttonTitle: "Próximo")])
    }
    
    func test_navigateToHomeIfNeeded_whenButtonTitleIsNil_shouldNotCallsDelegate() {
        let (sut, doubles) = makeSUT()
        
        sut.navigateToHomeIfNeeded(buttonTitle: nil)
        
        XCTAssertEqual(doubles.delegateSpy.receivedMessages, [])
    }
    
    func test_navigateToHomeIfNeeded_whenTitleIsDifferentFromWantToStart_shouldNotCallsDelegate() {
        let (sut, doubles) = makeSUT()
        
        sut.navigateToHomeIfNeeded(buttonTitle: "some title")
        
        XCTAssertEqual(doubles.delegateSpy.receivedMessages, [])
    }
    
    func test_navigateToHomeIfNeeded_whenTitleIsWantToStart_shouldShowMainScreenAnsSetupUserDefaults() {
        let (sut, doubles) = makeSUT()
        
        sut.navigateToHomeIfNeeded(buttonTitle: "Quero começar")
        
        XCTAssertEqual(doubles.delegateSpy.receivedMessages, [.showMainScreen])
        XCTAssertTrue(doubles.userDefaultsStub.bool(forKey: "onboard"))
    }
}

// MARK: - Helpers

private extension OnboardingVieeModelTests {
    typealias SutAndDoubles = (
        sut: OnboardingViewModel,
        doubles: (
            userDefaultsStub: UserDefaultsProtocolStub,
            delegateSpy: OnboardingViewModelDelegateSpy
        )
    )

    func makeSUT() -> SutAndDoubles {
        let userDefaultsStub = UserDefaultsProtocolStub()
        let delegateSpy = OnboardingViewModelDelegateSpy()
        let sut = OnboardingViewModel(defaults: userDefaultsStub)
        sut.delegate = delegateSpy
        
        return (sut, (userDefaultsStub, delegateSpy))
    }
}

// MARK: - UserDefaultsProtocolSpy

private class UserDefaultsProtocolStub: UserDefaultsProtocol {
    private var dictionary = [String: Bool]()
    
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
