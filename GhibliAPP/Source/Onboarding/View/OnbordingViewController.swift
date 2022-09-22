//
//  OnbordingViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 08/09/22.
//

import UIKit

final class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.pushViewController(FilmOverviewController(), animated: true)
    }
}
