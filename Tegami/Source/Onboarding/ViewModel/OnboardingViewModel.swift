//
//  Onboarding.swift
//  GhibliAPP
//
//  Created by Yago Marques on 19/09/22.
//

import UIKit

final class OnboardingViewModel {

    private let defaults = UserDefaults.standard

    var textContents = [
        ("Explore o vasto universo das animações do Studio Ghibli", ""),
        ("Barra de XP", "Maratone os filmes do Studio Ghibli e faça sua barra de XP crescer!! não esqueça de compartilhar sua evolução com os amigos"),
        ("Sua lista de filmes", "Procuramos os cinco filmes mais populares do Studio Ghibli e adicionamos à sua lista de filmes :)")
    ]

    func markOnboardAsWatched() {

        let data = try? JSONEncoder().encode(true)
        defaults.set(data, forKey: "onboard")
    }

    func onboardWasSeen() -> Bool {
        defaults.object(forKey: "onboard") == nil ? false : true
    }
}
