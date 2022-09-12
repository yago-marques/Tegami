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
            let api = APICall()
            guard let (data, status) = await api.GET(at: "https://ghibliapi.herokuapp.com/films") else { return }

            print(String(data: data, encoding: .utf8)!)
            print(status)
        }

    }
}
