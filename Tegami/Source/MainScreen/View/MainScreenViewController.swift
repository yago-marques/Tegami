//
//  MainScreenViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 21/09/22.
//

import UIKit

final class MainScreenViewController: UIViewController {

    private lazy var filmTable = FilmTableViewController(
        viewModel: FilmTableViewModel(
            mainScreenDelegate: self,
            userDefaults: UserDefaults.standard,
            loader: RemoteFilmLoader(api: URLSessionHTTPClient(session: .shared))),
        letterViewModel: self.letterView.viewModel,
        progressBar: self.letterView.progressBar
    )

    private lazy var letterView = LetterViewController(
        viewModel: LetterViewModel(
            table: FilmTableViewModel(
                mainScreenDelegate: self,
                userDefaults: UserDefaults.standard,
                loader: RemoteFilmLoader(api: URLSessionHTTPClient(session: .shared))) as LetterViewModelDelegate,
            mainScreenDelegate: self)
    )

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        buildLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

extension MainScreenViewController: MainScreenViewControllerDelegate {
    func move(to option: ScrollMovement) {
        switch option {
        case .bottom:
            scrollView.scrollToBottom()
        case .top:
            scrollView.moveToTop()
        }
    }
}

extension MainScreenViewController: ViewCoding {
    func setupView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        self.scrollView.contentSize = CGSize(
            width:view.frame.width,
            height: 2 * view.frame.height
        )
        self.scrollView.scrollToBottom()
    }

    func setupHierarchy() {
        view.addSubview(scrollView)

        addChild(letterView)
        letterView.willMove(toParent: self)
        scrollView.addSubview(letterView.view)
        letterView.didMove(toParent: self)

        addChild(filmTable)
        filmTable.willMove(toParent: self)
        scrollView.addSubview(filmTable.view)
        filmTable.didMove(toParent: self)
    }

    func setupConstraints() {
        filmTable.view.translatesAutoresizingMaskIntoConstraints = false
        letterView.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            filmTable.view.widthAnchor.constraint(equalToConstant: view.frame.width),
            filmTable.view.heightAnchor.constraint(equalToConstant: view.frame.height),

            letterView.view.topAnchor.constraint(equalTo: filmTable.view.bottomAnchor),
            letterView.view.widthAnchor.constraint(equalToConstant: view.frame.width),
            letterView.view.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])

    }
}
