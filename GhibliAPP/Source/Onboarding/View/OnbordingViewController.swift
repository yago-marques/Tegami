//
//  OnbordingViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 08/09/22.
//

import UIKit

final class OnbordingViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .blue
        Task {
            let viewModel = MainScreenViewModel()
            let filmList = await viewModel.fetchTmdbInfo(originalTitle: "天空の城ラピュタ")

        }

    }
}
