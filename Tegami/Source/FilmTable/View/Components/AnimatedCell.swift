//
//  AnimatedCell.swift
//  Tegami
//
//  Created by Yago Marques on 28/09/22.
//

import UIKit
import Lottie

final class AnimatedCell: UITableViewCell {

    var animationConfig: AnimationConfig? = nil {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let self, let lottieName = self.animationConfig?.lottieName {
                    self.messageLabel.text = self.animationConfig?.message
                    self.showAnimation(of: lottieName)
                }
            }
        }
    }

    private let cardStack: UIView = {
        let stack = UIView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    private var loadingAnimation: AnimationView = {
        var lottie = AnimationView(name: "loading")
        lottie.loopMode = .loop
        lottie.animationSpeed = 0.5
        lottie.translatesAutoresizingMaskIntoConstraints = false

        return lottie
    }()

    private var emptyAnimation: AnimationView = {
        var lottie = AnimationView(name: "emptyList")
        lottie.loopMode = .loop
        lottie.animationSpeed = 0.5
        lottie.translatesAutoresizingMaskIntoConstraints = false

        return lottie
    }()

    private let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("error FilmCardCell")
    }

    func showAnimation(of lottieName: String) {
        if lottieName == "loading" {
            cardStack.addSubview(loadingAnimation)
            emptyAnimation.removeFromSuperview()
            loadingAnimation.play()

            NSLayoutConstraint.activate([
                loadingAnimation.topAnchor.constraint(equalTo: cardStack.topAnchor),
                loadingAnimation.heightAnchor.constraint(equalTo: cardStack.widthAnchor, multiplier: 0.8),
                loadingAnimation.centerXAnchor.constraint(equalTo: cardStack.centerXAnchor),
            ])
        } else {
            cardStack.addSubview(emptyAnimation)
            loadingAnimation.removeFromSuperview()
            emptyAnimation.play()

            NSLayoutConstraint.activate([
                emptyAnimation.topAnchor.constraint(equalToSystemSpacingBelow: cardStack.topAnchor, multiplier: 5),
                emptyAnimation.heightAnchor.constraint(equalTo: cardStack.widthAnchor, multiplier: 0.5),
                emptyAnimation.centerXAnchor.constraint(equalTo: cardStack.centerXAnchor)
            ])
        }
    }

}

extension AnimatedCell: ViewCoding {
    func setupView() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }

    func setupHierarchy() {
        self.addSubview(cardStack)
        cardStack.addSubview(messageLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cardStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cardStack.widthAnchor.constraint(equalTo: self.widthAnchor),
            cardStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),

            messageLabel.topAnchor.constraint(equalTo: cardStack.topAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: cardStack.centerXAnchor),
        ])
    }
}
