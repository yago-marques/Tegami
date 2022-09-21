//
//  SceneView.swift
//  GhibliAPP
//
//  Created by Yago Marques on 21/09/22.
//

import UIKit

final class SceneView: UIView {

    private lazy var backgroundImage: UIImageView = {
        self.makeImageView(named: "Elementos/fundoB-tree", contentMode: .scaleAspectFill)
    }()

    private lazy var cloudImage: UIImageView = {
        self.makeImageView(named: "Elementos/aCloud", contentMode: .scaleAspectFit)
    }()

    private lazy var grassImage: UIImageView = {
        self.makeImageView(named: "Elementos/aGrass", contentMode: .scaleAspectFit)
    }()

    private lazy var treeImage: UIImageView = {
        self.makeImageView(named: "Arvore/stage5", contentMode: .scaleAspectFit)
    }()

    init() {
        super.init(frame: .zero)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("error SceneView")
    }
}

extension SceneView {
    func makeImageView(named: String, contentMode: UIView.ContentMode) -> UIImageView {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: named)
        image.contentMode = contentMode

        return image
    }

    func configureTreeStageFive() {
        NSLayoutConstraint.activate([
            treeImage.widthAnchor.constraint(equalTo: grassImage.widthAnchor, multiplier: 1.3),
            treeImage.heightAnchor.constraint(equalTo: treeImage.widthAnchor),
            treeImage.bottomAnchor.constraint(equalToSystemSpacingBelow: grassImage.topAnchor, multiplier: 13),
            treeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension SceneView: ViewCoding {
    func setupView() { }

    func setupHierarchy() {
        self.addSubview(backgroundImage)
        self.addSubview(cloudImage)
        self.addSubview(grassImage)
        self.addSubview(treeImage)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            cloudImage.bottomAnchor.constraint(equalToSystemSpacingBelow: grassImage.topAnchor, multiplier: 15),
            cloudImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 3),
            cloudImage.heightAnchor.constraint(equalTo: cloudImage.widthAnchor, multiplier: 0.43),
            cloudImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            grassImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            grassImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            grassImage.heightAnchor.constraint(equalTo: grassImage.widthAnchor, multiplier: 0.59),
            grassImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        configureTreeStageFive()

    }
}
