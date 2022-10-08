//
//  Onboarding.swift
//  GhibliAPP
//
//  Created by Yago Marques on 19/09/22.
//

import UIKit

protocol OnboardingViewModeling {
    func getModel(at index: Int) -> OnboardingModel
    func numberOfRows() -> Int
    func presentOnboardingIfNeeded()
    func setupTitle(at index: Int)
    func navigateToHomeIfNeeded(buttonTitle: String?)
}

protocol OnboardginViewModelDelegate: AnyObject {
    func showOnboarding()
    func showMainScreen()
    func setup(buttonTitle: String)
    func displayScreen(at index: Int)
}

final class OnboardingViewModel: OnboardingViewModeling {
    private enum ButtonType: String {
        case next = "Próximo"
        case start = "Quero começar"
    }
    
    var models: [OnboardingModel] {
        return [
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
    }

    private let defaults: UserDefaultsProtocol
    weak var delegate: OnboardginViewModelDelegate?

    init(defaults: UserDefaultsProtocol) {
        self.defaults = defaults
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
    
    func setupTitle(at index: Int) {
        let type: ButtonType = index == 2 ? .start : .next
        delegate?.setup(buttonTitle: type.rawValue)
    }
    
    func navigateToHomeIfNeeded(buttonTitle: String?) {
        if let buttonTitle, buttonTitle == ButtonType.start.rawValue {
            delegate?.showMainScreen()
            defaults.setBool(true, forKey: "onboard")
        }
    }
}
