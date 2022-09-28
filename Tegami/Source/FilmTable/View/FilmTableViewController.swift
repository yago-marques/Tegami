//
//  MainScreenViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 15/09/22.
//

import UIKit
import Lottie

final class FilmTableViewController: UIViewController {

    private let viewModel: FilmTableViewModel
    weak var letterViewModel: LetterViewModel?
    weak var progressBar: ProgressBar?

    private let backgroundImage: UIImageView = {
        let background = UIImageView(frame: .zero)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.image = UIImage(named: "fundoA-list")
        background.contentMode = .scaleAspectFill

        return background
    }()

    lazy var bottomCloudImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "aCloud")
        image.contentMode = .scaleAspectFit

        return image
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Pesquisar filme"
        searchBar.sizeToFit()
        searchBar.delegate = self

        return searchBar
    }()

    private lazy var tableHeaderView: FilmTableHeader = {
        let header = FilmTableHeader(delegate: self)
        header.translatesAutoresizingMaskIntoConstraints = false

        return header
    }()

    private lazy var filmsTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(FilmCardCell.self, forCellReuseIdentifier: "FilmCardCell")
        table.register(AnimatedCell.self, forCellReuseIdentifier: "AnimatedCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.allowsSelection = true
        table.isUserInteractionEnabled = true
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false

        return table
    }()

    private lazy var arrowView: AnimationView = {
        var lottie = AnimationView(name: "arrow")
        lottie.frame = self.view.bounds
        lottie.loopMode = .loop
        lottie.animationSpeed = 0.5
        lottie.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollToBottom))
        lottie.addGestureRecognizer(tap)

        return lottie

    }()

    init(
        viewModel: FilmTableViewModel,
        letterViewModel: LetterViewModel,
        progressBar: ProgressBar
    ) {
        self.viewModel = viewModel
        self.letterViewModel = letterViewModel
        self.progressBar = progressBar
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("error MainScreenViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buildLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task.detached {
            await self.viewModel.fetchFilms()
        }
    }

    @objc func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            if let self {
                self.viewModel.mainScreenDelegate?.move(to: .bottom)
            }
        }
    }

}

extension FilmTableViewController: FilmTableViewModelDelegate {
    func reloadTable() {
        UIView.transition(
            with: filmsTableView,
            duration: 0.7,
            options: .transitionCrossDissolve,
            animations: {
                self.filmsTableView.reloadData()
            }
        )
    }

    func isInterective(_ option: Bool) {
        DispatchQueue.main.async { [weak self] in
            if let self {
                self.view.isUserInteractionEnabled = option
            }
        }
    }
}

extension FilmTableViewController: FilmTableHeaderDelegate {
    func allFilms() {
        viewModel.showAllMovies()
    }

    func moviesToWatch() {
        viewModel.showMoviesToWatch()
    }
}

extension FilmTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        viewModel.filterContentForSearchText(searchText: textSearched)
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.TableIsEmpty = false
        let tapGestureToHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureToHideKeyboard)

        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        view.gestureRecognizers = []

        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    @objc func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }
}

extension FilmTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // overView is open here
        print("toOverview")
    }
}

extension FilmTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = !viewModel.isSearch ? viewModel.films.count : viewModel.filteredFilms.count

        if !viewModel.isSearch, viewModel.tableState == .toWatch, rows == 0 {
            viewModel.TableIsEmpty = true
            return 1
        }

        if !viewModel.isSearch, viewModel.tableState == .all, rows == 0 {
            viewModel.loadingFilms = true
            return 1
        }

        return rows
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.TableIsEmpty || viewModel.loadingFilms ? UIScreen.main.bounds.height/1.5 : UIScreen.main.bounds.height/4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.TableIsEmpty || viewModel.loadingFilms {
            let config = viewModel.TableIsEmpty ? AnimationConfig(lottieName: "EmptyList", message: "Lista vazia") : AnimationConfig(lottieName: "loading", message: "Carregando filmes")
            let animatedCell = tableView.dequeueReusableCell(withIdentifier: "AnimatedCell", for: indexPath) as! AnimatedCell
            animatedCell.animationConfig = config

            return animatedCell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCardCell", for: indexPath) as! FilmCardCell
        let film = !viewModel.isSearch ? viewModel.films[indexPath.row] : viewModel.filteredFilms[indexPath.row]
        cell.film = film
        cell.selectionStyle = .none
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(LongPresshandler)
        )
        cell.addGestureRecognizer(longPressGesture)

        return cell

    }

    @objc func LongPresshandler(_ sender: UILongPressGestureRecognizer) {
        let cell = sender.view as! UITableViewCell
        guard let indexPath = filmsTableView.indexPath(for: cell) else { return }
        let mySheet = ActionSheet(delegate: self.viewModel)

        if sender.state == .began, !viewModel.isSearch {
            let film = viewModel.films[indexPath.row]
            mySheet.film = film
            switch viewModel.tableState {
            case .all:
                mySheet.contentOfRowAt = viewModel.getActions(state: .all)
            case .toWatch:
                if indexPath.row == 0 {
                    mySheet.contentOfRowAt = viewModel.getActions(state: .toWatch, isFirst: true)
                } else {
                    mySheet.contentOfRowAt = viewModel.getActions(state: .toWatch)
                }
            }

            let hapticSoft = UIImpactFeedbackGenerator(style: .soft)
            let hapticRigid = UIImpactFeedbackGenerator(style: .rigid)

            hapticSoft.impactOccurred(intensity: 1.00)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                hapticRigid.impactOccurred(intensity: 1.00)
            }

            if let sheet = mySheet.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
                present(mySheet, animated: true)
            }
        }
    }
}

extension FilmTableViewController: ViewCoding {
    func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        viewModel.delegate = self
        viewModel.letterDelegate = letterViewModel
        viewModel.progressBarDelegate = progressBar
        arrowView.play()
    }

    func setupHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(bottomCloudImage)
        view.addSubview(searchBar)
        view.addSubview(tableHeaderView)
        view.addSubview(filmsTableView)
        view.addSubview(arrowView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableHeaderView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableHeaderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableHeaderView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
            tableHeaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            filmsTableView.topAnchor.constraint(equalToSystemSpacingBelow: tableHeaderView.bottomAnchor, multiplier: 1),
            filmsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            filmsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filmsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            bottomCloudImage.centerYAnchor.constraint(equalTo: view.bottomAnchor),
            bottomCloudImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomCloudImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.3),
            bottomCloudImage.heightAnchor.constraint(equalTo: bottomCloudImage.widthAnchor, multiplier: 0.58),

            arrowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            arrowView.topAnchor.constraint(equalToSystemSpacingBelow: bottomCloudImage.topAnchor, multiplier: 5),
            arrowView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            arrowView.heightAnchor.constraint(equalTo: arrowView.widthAnchor, multiplier: 0.9)
        ])
    }
}
