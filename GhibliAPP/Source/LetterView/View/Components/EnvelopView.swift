//
//  EnvelopView.swift
//  GhibliAPP
//
//  Created by Yago Marques on 22/09/22.
//

import UIKit

final class EnvelopView: UIView {

    weak var delegate: EnvelopViewDelegate?

    var film: FilmModel = FilmModel(ghibli: nil, tmdb: nil) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let film = self?.film {
                    self?.nextFilmCard.film = film
                }
            }
        }
    }

    private var showLetterPaper = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.addFilmStack()
                self?.addfilmCard()
                self?.addLetterPin()
            }
        }
    }

    private var letterName = "Cartas/1" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let letter = self?.letterImage {
                    UIView.transition(
                        with: letter,
                        duration: 0.4,
                        options: .transitionFlipFromLeft,
                        animations: {
                            letter.image = UIImage(named: self?.letterName ?? "Cartas/1")
                        }
                    )
                    letter.isUserInteractionEnabled = false
                }

            }
        }
    }

    private lazy var letterImage: UIImageView = {
        let image = self.makeImageView(named: letterName, contentMode: .scaleAspectFit)
        image.transform = image.transform.rotated(by: CGFloat(Double.pi/15))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLetter))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true

        return image
    }()

    private lazy var letterPinImage: UIImageView = {
        self.makeImageView(named: "Cartas/selo", contentMode: .scaleAspectFit)
    }()

    private let filmStack: UIView = {
        let stack = UIView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    private lazy var nextFilmCard: NextFilmView = {
        let nextFilm = NextFilmView()
        nextFilm.translatesAutoresizingMaskIntoConstraints = false

        return nextFilm
    }()

    init(delegate: EnvelopViewDelegate) {
        self.delegate = delegate
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
        UIView.animate(withDuration: 1.5, delay: 0.6, animations: {}, completion: { _ in
            UIView.animate(withDuration: 1, delay: 0.3, options: [.curveEaseOut], animations: {
                self.letterImage.frame.origin.x -= 300
                self.letterImage.frame.origin.y += 150
            })
        })
    }

    @objc func openLetter() {
        openLetterHaptics()
        openLetterAnimation()
        swapLetterImage()
    }

    func openLetterAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.1, animations: {}, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut], animations: {
                self.letterImage.transform = self.transform.rotated(by: CGFloat(0))
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
                    self.letterImage.frame.origin.y += 10
                })
            })
        })
    }

    func openLetterHaptics() {
        let hapticSoft = UIImpactFeedbackGenerator(style: .soft)
        let hapticRigid = UIImpactFeedbackGenerator(style: .rigid)

        hapticSoft.impactOccurred(intensity: 1.00)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            hapticRigid.impactOccurred(intensity: 1.00)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            hapticSoft.impactOccurred(intensity: 1.00)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            hapticSoft.impactOccurred(intensity: 1.00)
            hapticRigid.impactOccurred(intensity: 1.00)
        }
    }

    func swapLetterImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.letterName = "Cartas/2"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            self.showLetterPaper = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            self.delegate?.moveLetterToTop()
        }
    }

    func addFilmStack() {
        self.addSubview(filmStack)

        NSLayoutConstraint.activate([
            filmStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            filmStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            filmStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            filmStack.heightAnchor.constraint(equalTo: filmStack.widthAnchor, multiplier: 0.6)
        ])

        animateFilmStack()
    }

    func addfilmCard() {
        self.addSubview(nextFilmCard)

        NSLayoutConstraint.activate([
            nextFilmCard.centerXAnchor.constraint(equalTo: filmStack.centerXAnchor),
            nextFilmCard.centerYAnchor.constraint(equalTo: filmStack.centerYAnchor),
            nextFilmCard.heightAnchor.constraint(equalTo: filmStack.heightAnchor, multiplier: 0.9),
            nextFilmCard.widthAnchor.constraint(equalTo: filmStack.widthAnchor, multiplier: 0.95)
        ])

        animateFilmCard()
    }

    func addLetterPin() {
        self.addSubview(letterPinImage)

        NSLayoutConstraint.activate([
            letterPinImage.centerYAnchor.constraint(equalTo: filmStack.bottomAnchor),
            letterPinImage.widthAnchor.constraint(equalTo: filmStack.widthAnchor, multiplier: 0.2),
            letterPinImage.heightAnchor.constraint(equalTo: letterPinImage.widthAnchor),
            letterPinImage.trailingAnchor.constraint(equalToSystemSpacingAfter: filmStack.trailingAnchor, multiplier: 0)
        ])

        animateLetterPin()
    }

    func animateFilmStack() {
        UIView.animate(withDuration: 0.6, delay: 0.2, animations: {}, completion: { _ in
            UIView.animate(withDuration: 0.7, delay: 0.2, options: [.curveEaseOut], animations: {
                self.filmStack.frame.origin.y -= 20
                self.filmStack.backgroundColor = .systemGray5
                self.filmStack.layer.opacity = 0.8
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                    self.filmStack.frame.origin.y += 20
                })
            })
        })
    }

    func animateFilmCard() {
        UIView.animate(withDuration: 0.6, delay: 0.2, animations: {}, completion: { _ in
            UIView.animate(withDuration: 0.7, delay: 0.2, options: [.curveEaseOut], animations: {
                self.nextFilmCard.frame.origin.y -= 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                    self.nextFilmCard.frame.origin.y += 20
                })
            })
        })
    }

    func animateLetterPin() {
        UIView.animate(withDuration: 0.6, delay: 0.2, animations: {}, completion: { _ in
            UIView.animate(withDuration: 0.7, delay: 0.2, options: [.curveEaseOut], animations: {
                self.letterPinImage.frame.origin.y -= 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                    self.letterPinImage.frame.origin.y += 20
                })
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
