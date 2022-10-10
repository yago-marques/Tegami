//
//  OnboardingFactory.swift
//  Tegami
//
//  Created by MateuSales on 07/10/22.
//

import UIKit

enum OnboardingFactory {
    static func make() -> UIViewController {
        let viewModel = OnboardingViewModel(defaults: UserDefaultsHelper())
        let viewController = OnboardingViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        return viewController
    }
}


