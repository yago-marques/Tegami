//
//  ProgressBar.swift
//  GhibliAPP
//
//  Created by Yago Marques on 26/09/22.
//

import UIKit

final class ProgressBar: UIView {

    var watchedFilms: Double = 0.0 {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.animateBar()
                self?.updateLabel()
            }
        }
    }

    private let barShape: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "cRed")
        view.layer.cornerCurve = .circular
        view.layer.cornerRadius = 15
        view.layer.opacity = 0.5

        return view
    }()

    private lazy var progressShape: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "cRed")
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.layer.cornerCurve = .circular
        view.layer.cornerRadius = 15

        return view
    }()

    private let progressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white

        return label
    }()

    init() {
        super.init(frame: .zero)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("error ProgressBar")
    }

    func animateBar() {
        UIView.transition(
            with: self.progressShape,
            duration: 0.7,
            options: .transitionFlipFromRight,
            animations: {
                self.progressShape.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: self.frame.width * self.watchedFilms/22,
                    height: self.frame.height)
                self.layoutIfNeeded()
            }
        )
    }

    func updateLabel() {
        self.progressLabel.text = "\(Int(self.watchedFilms)) de 22 filmes"
        if self.watchedFilms > 21 {
            self.progressShape.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            self.progressLabel.text = "Parabéns por completar o Tegami!"
            self.progressLabel.adjustsFontSizeToFitWidth = true
            self.progressShape.backgroundColor = UIColor(named: "cBlue2")
            self.progressShape.layer.borderWidth = 1
            self.progressShape.layer.borderColor = UIColor(named: "cBlue")?.cgColor
        }
    }
}

extension ProgressBar: ProgressBarDelegate {
    func updateBar(watchedFilms: Double) {
        self.watchedFilms = watchedFilms
    }
}

extension ProgressBar: ViewCoding {
    func setupView() {
        self.backgroundColor = .clear
    }

    func setupHierarchy() {
        self.addSubview(barShape)
        self.addSubview(progressShape)
        self.addSubview(progressLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            barShape.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            barShape.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            barShape.widthAnchor.constraint(equalTo: self.widthAnchor),
            barShape.heightAnchor.constraint(equalTo: self.heightAnchor),

            progressLabel.centerXAnchor.constraint(equalTo: barShape.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: barShape.centerYAnchor),
            progressLabel.widthAnchor.constraint(equalTo: barShape.widthAnchor, multiplier: 0.7),
            progressLabel.heightAnchor.constraint(equalTo: barShape.heightAnchor, multiplier: 0.95)
        ])
    }
}
