//
//  OnboardingCell.swift
//  Tegami
//
//  Created by Yago Marques on 29/09/22.
//

import UIKit
import Lottie

final class OnboardingCell: UICollectionViewCell {

    var cellOption: Int = 1 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let self {
                    self.showCell(at: self.cellOption)
                }
            }
        }
    }

    var textContent: (title: String, message: String) = ("", "") {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let self {
                    self.titleLabel.text = self.textContent.title
                    self.messageLabel.text = self.textContent.message
                }
            }
        }
    }

    private lazy var totoroImage: UIImageView = {
        self.makeImageView(named: "totoroAndOthers", contentMode: .scaleAspectFit)
    }()

    private lazy var catImage: UIImageView = {
        self.makeImageView(named: "cat", contentMode: .scaleAspectFit)
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)

        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    private lazy var progressAnimation: AnimationView = {
        var lottie = AnimationView(name: "progress")
        lottie.frame = self.bounds
        lottie.loopMode = .loop
        lottie.animationSpeed = 0.3
        lottie.translatesAutoresizingMaskIntoConstraints = false

        return lottie
    }()

    private lazy var listAnimation: AnimationView = {
        var lottie = AnimationView(name: "filmList")
        lottie.frame = self.bounds
        lottie.loopMode = .loop
        lottie.animationSpeed = 0.5
        lottie.translatesAutoresizingMaskIntoConstraints = false
        lottie.contentMode = .scaleAspectFit

        return lottie
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("Error - TextPostCell")
    }

    func makeImageView(named: String, contentMode: UIView.ContentMode) -> UIImageView {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: named)
        image.contentMode = contentMode

        return image
    }

    func showCell(at index: Int) {
        switch index {
        case 0:
            showTotoroImage()
        case 1:
            showCatImage()
            showProgressAnimation()
        case 2:
            showListAnimation()
        default:
            print("error")
        }
    }

    func showTotoroImage() {
        self.addSubview(totoroImage)

        NSLayoutConstraint.activate([
            totoroImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            totoroImage.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 10),
            totoroImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            totoroImage.heightAnchor.constraint(equalTo: totoroImage.widthAnchor, multiplier: 0.8)
        ])
    }

    func showCatImage() {
        self.addSubview(catImage)

        NSLayoutConstraint.activate([
            catImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            catImage.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 3),
            catImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            catImage.heightAnchor.constraint(equalTo: catImage.widthAnchor, multiplier: 2)
        ])
    }

    func showProgressAnimation() {
        self.addSubview(progressAnimation)

        NSLayoutConstraint.activate([
            progressAnimation.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            progressAnimation.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15),
            progressAnimation.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            progressAnimation.heightAnchor.constraint(equalTo: progressAnimation.widthAnchor, multiplier: 0.2)
        ])

        progressAnimation.play()
    }

    func showListAnimation() {
        self.addSubview(listAnimation)

        NSLayoutConstraint.activate([
            listAnimation.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            listAnimation.topAnchor.constraint(equalTo: self.topAnchor),
            listAnimation.widthAnchor.constraint(equalTo: self.widthAnchor),
            listAnimation.heightAnchor.constraint(equalTo: listAnimation.widthAnchor, multiplier: 1.5)
        ])

        listAnimation.play()
    }
}

extension OnboardingCell: ViewCoding {
    func setupView() {
        self.backgroundColor = .systemBackground
    }

    func setupHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(messageLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: self.frame.height * 0.06),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),

            messageLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
            messageLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
