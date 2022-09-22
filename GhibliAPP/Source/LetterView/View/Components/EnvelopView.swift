//
//  EnvelopView.swift
//  GhibliAPP
//
//  Created by Yago Marques on 22/09/22.
//

import UIKit

final class EnvelopView: UIView {

    private lazy var letterImage: UIImageView = {
        let image = self.makeImageView(named: "Cartas/1", contentMode: .scaleAspectFit)
        image.transform = image.transform.rotated(by: CGFloat(Double.pi/12))

        return image
    }()

    init() {
        super.init(frame: .zero)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("error EnvelopView")
    }

}

extension EnvelopView {
    func makeImageView(named: String, contentMode: UIView.ContentMode) -> UIImageView {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: named)
        image.contentMode = contentMode

        return image
    }

    func animateLetter() {
        UIView.animateKeyframes(withDuration: 4, delay: 0, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                self.letterImage.backgroundColor = .magenta
            })

            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.letterImage.alpha = 0.5
            })
            UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25, animations: {
                self.letterImage.center.x = self.bounds.width - 100
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.letterImage.center.x = self.bounds.width - 200
            })
        })
    }

}

extension EnvelopView: ViewCoding {
    func setupView() {
        animateLetter()
    }

    func setupHierarchy() {
        self.addSubview(letterImage)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            letterImage.topAnchor.constraint(equalTo: self.topAnchor),
            letterImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            letterImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            letterImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
