//
//  OnboardingViewModelTests.swift
//  TegamiTests
//
//  Created by Yago Marques on 06/10/22.
//

import XCTest
@testable import Tegami

final class OnboardingViewModelTests: XCTestCase {
    let mockedDefaults = MockUserDefaults()
    lazy var viewModel = OnboardingViewModel(defaults: self.mockedDefaults)

    // MARK: markOnboardAsWatched method
    func test_markOnboardAsWatched_setOnboardOnDefaults() {
        viewModel.markOnboardAsWatched()

        XCTAssertTrue(mockedDefaults.setOnboarding)
    }

    // MARK: markOnboardAsWatched method
    func test_verifyIfonboardWasSeen_booleanStatus() {
        let status = viewModel.onboardWasSeen()

        XCTAssertTrue(status)
    }

    func test_verifyIfonboardWasSeenWithInvalidKey_booleanStatus() {
        let status = viewModel.onboardWasSeen(onboardKey: "invalid")

        XCTAssertFalse(status)
    }
}
