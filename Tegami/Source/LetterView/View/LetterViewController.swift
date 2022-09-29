//
//  LatterViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 21/09/22.
//

import UIKit
import Lottie

final class LetterViewController: UIViewController {

    private(set) var viewModel: LetterViewModel

    init(viewModel: LetterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let sceneView: SceneView = {
        let scene = SceneView()
        scene.translatesAutoresizingMaskIntoConstraints = false

        return scene
    }()

    private lazy var envelopView: EnvelopView = {
        let envelop = EnvelopView(delegate: self)
        envelop.translatesAutoresizingMaskIntoConstraints = false

        return envelop
    }()

    private(set) lazy var progressBar: ProgressBar = {
        let bar = ProgressBar()
        bar.watchedFilms = self.viewModel.getWatchedFilms() ?? 0
        bar.translatesAutoresizingMaskIntoConstraints = false

        return bar
    }()

    private lazy var arrowView: AnimationView = {
        var lottie = AnimationView(name: "arrow")
        lottie.frame = self.view.bounds
        lottie.loopMode = .loop
        lottie.animationSpeed = 0.5
        lottie.transform = lottie.transform.rotated(by: CGFloat(Double.pi/1))
        lottie.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollToTop))
        lottie.addGestureRecognizer(tap)

        return lottie

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        buildLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task.detached {
            await self.viewModel.fetchNextMovieToWatch()
        }
    }

    @objc func scrollToTop() {
        DispatchQueue.main.async { [weak self] in
            if let self {
                self.viewModel.mainScreenDelegate?.move(to: .top)
            }
        }
    }

}

extension LetterViewController: EnvelopViewDelegate {
    func moveLetterToTop() {
        UIView.animate(withDuration: 0.6, delay: 0.2, animations: {}, completion: { _ in
            UIView.animate(withDuration: 0.7, delay: 0.2, options: [.curveEaseOut], animations: {
                self.envelopView.frame.origin.y -= self.view.frame.height/20
            })
        })
    }
}

extension LetterViewController: LetterViewControllerDelegate {
    func addFilmToStack(film: FilmModel, counter: Int) {
        self.envelopView.film = film
        var labelText: String = "Seu próximo filme"

        if counter == 0, film.ghibli == nil {
            labelText = "Lista vazia"
        }

        if counter > 0, film.ghibli == nil {
            labelText = "Último filme removido da lista"
        }

        self.modifyTitleLabel(labelTitle: labelText)
    }

    func modifyTitleLabel(labelTitle: String) {
        self.envelopView.nextFilmCard.labelText = labelTitle
    }
}

extension LetterViewController: ViewCoding {
    func setupView() {
        navigationItem.hidesBackButton = true
        viewModel.delegate = self

        arrowView.play()
    }

    func setupHierarchy() {
        view.addSubview(sceneView)
        view.addSubview(envelopView)
        view.sendSubviewToBack(sceneView)
        view.addSubview(progressBar)
        view.addSubview(arrowView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            envelopView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            envelopView.centerYAnchor.constraint(equalTo: sceneView.cloudImage.centerYAnchor),
            envelopView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            envelopView.heightAnchor.constraint(equalTo: envelopView.widthAnchor, multiplier: 0.8),

            progressBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            progressBar.heightAnchor.constraint(equalTo: progressBar.widthAnchor, multiplier: 0.10),
            progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBar.bottomAnchor.constraint(equalToSystemSpacingBelow: sceneView.cloudImage.bottomAnchor, multiplier: 7 ),

            arrowView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 15),
            arrowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            arrowView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            arrowView.heightAnchor.constraint(equalTo: arrowView.widthAnchor, multiplier: 0.9)
        ])
    }
}
