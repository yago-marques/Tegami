//
//  Onboarding.swift
//  GhibliAPP
//
//  Created by Yago Marques on 19/09/22.
//

import UIKit

final class OnboardingViewModel {

    private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    var textContents = [
        ("Explore o vasto universo das animações do Studio Ghibli", ""),
        ("Barra de XP", "Maratone os filmes do Studio Ghibli e faça sua barra de XP crescer!! não esqueça de compartilhar sua evolução com os amigos"),
        ("Sua lista de filmes", "Procuramos os cinco filmes mais populares do Studio Ghibli e adicionamos à sua lista de filmes :)")
    ]

    func markOnboardAsWatched() {
        defaults.set(true, forKey: "onboard")
    }

    func onboardWasSeen(onboardKey: String = "onboard") -> Bool {
        defaults.bool(forKey: "onboard")
    }
}
