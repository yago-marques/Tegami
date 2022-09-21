//
//  LatterViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 21/09/22.
//

import UIKit

final class LetterViewController: UIViewController {

    private let sceneView: SceneView = {
        let scene = SceneView()
        scene.translatesAutoresizingMaskIntoConstraints = false

        return scene
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        buildLayout()
    }

}

extension LetterViewController: ViewCoding {
    func setupView() {
        view.backgroundColor = .red
        navigationItem.hidesBackButton = true
    }

    func setupHierarchy() {
        view.addSubview(sceneView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
