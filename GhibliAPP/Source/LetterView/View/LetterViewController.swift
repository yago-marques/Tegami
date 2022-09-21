//
//  LatterViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 21/09/22.
//

import UIKit

final class LetterViewController: UIViewController {

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

    func setupHierarchy() { }

    func setupConstraints() { }
}
