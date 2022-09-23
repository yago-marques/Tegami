//
//  LatterViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 21/09/22.
//

import UIKit

final class LetterViewController: UIViewController {

    private let viewModel: LetterViewModel

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

}

extension LetterViewController: EnvelopViewDelegate {
    func moveLetterToTop() {
        UIView.animate(withDuration: 0.6, delay: 0.2, animations: {}, completion: { _ in
            UIView.animate(withDuration: 0.7, delay: 0.2, options: [.curveEaseOut], animations: {
                self.envelopView.frame.origin.y -= self.view.frame.height/4
            })
        })
    }
}

extension LetterViewController: LetterViewControllerDelegate {
    func addFilmToStack(film: FilmModel) {
        self.envelopView.film = film
    }
}

extension LetterViewController: ViewCoding {
    func setupView() {
        view.backgroundColor = .red
        navigationItem.hidesBackButton = true
        viewModel.delegate = self
    }

    func setupHierarchy() {
        view.addSubview(sceneView)
        view.addSubview(envelopView)
        view.sendSubviewToBack(sceneView)
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
            envelopView.heightAnchor.constraint(equalTo: envelopView.widthAnchor, multiplier: 0.8)
        ])
    }
}
