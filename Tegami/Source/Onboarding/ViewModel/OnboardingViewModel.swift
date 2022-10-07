//
//  Onboarding.swift
//  GhibliAPP
//
//  Created by Yago Marques on 19/09/22.
//

import UIKit

protocol OnboardingViewModeling {
    func markOnboardAsWatched()
    func getModel(at index: Int) -> OnboardingModel
    func numberOfRows() -> Int
    func presentOnboardingIfNeeded()
}

protocol OnboardginViewModelDelegate: AnyObject {
    func showOnboarding()
    func showMainScreen()
}

final class OnboardingViewModel: OnboardingViewModeling {
    private let defaults: UserDefaults
    private let models: [OnboardingModel] = [
        .init(
            title: "Explore o vasto universo das animações do Studio Ghibli",
            description: ""
        ),
        .init(
            title: "Barra de XP",
            description: "Maratone os filmes do Studio Ghibli e faça sua barra de XP crescer!! não esqueça de compartilhar sua evolução com os amigos"
        ),
        .init(
            title: "Sua lista de filmes",
            description: "Procuramos os cinco filmes mais populares do Studio Ghibli e adicionamos à sua lista de filmes :)"
        )
    ]

    weak var delegate: OnboardginViewModelDelegate?

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    func markOnboardAsWatched() {
        defaults.set(true, forKey: "onboard")
    }
    
    func getModel(at index: Int) -> OnboardingModel {
        return models[index]
    }
    
    func numberOfRows() -> Int {
        return models.count
    }
    
    func presentOnboardingIfNeeded() {
        let onboardWasSeen = defaults.bool(forKey: "onboard")
        onboardWasSeen ? delegate?.showMainScreen() : delegate?.showOnboarding()
    }
}
