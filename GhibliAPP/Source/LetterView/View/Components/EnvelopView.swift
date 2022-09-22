//
//  EnvelopView.swift
//  GhibliAPP
//
//  Created by Yago Marques on 22/09/22.
//

import UIKit

final class EnvelopView: UIView {

    private var isInAnimation = false {
        didSet {
            animateLetter()
        }
    }

    private lazy var letterImage: UIImageView = {
        let image = self.makeImageView(named: "Cartas/1", contentMode: .scaleAspectFit)
        image.transform = image.transform.rotated(by: CGFloat(Double.pi/15))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLetter))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true

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
        if isInAnimation {
            UIView.animate(withDuration: 1.5, delay: 0.6, animations: {}, completion: { _ in
                UIView.animate(withDuration: 1, delay: 0.3, options: [.repeat, .autoreverse, .curveEaseOut], animations: {
                    self.letterImage.frame.origin.y += 10
                })
            })
        }
    }

    @objc func openLetter() {
        self.isInAnimation = false
        openLetterAnimation()
    }

    func openLetterAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0.6, animations: {}, completion: { _ in
            UIView.animate(withDuration: 1, delay: 0.3, options: [.curveEaseOut], animations: {
                self.letterImage.transform = self.transform.rotated(by: CGFloat(0))
            }, completion: { _ in
                UIView.animate(withDuration: 1, delay: 0.3, animations: {
                    self.letterImage.frame.origin.y += 10
                })
            })
        })

    }

}

extension EnvelopView: ViewCoding {
    func setupView() {
        self.isInAnimation = true
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
