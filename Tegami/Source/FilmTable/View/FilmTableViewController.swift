//
//  MainScreenViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 15/09/22.
//

import UIKit

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
        let film = !viewModel.isSearch ? self.viewModel.films[indexPath.row] : self.viewModel.filteredFilms[indexPath.row]

        navigationController?.pushViewController(
            FilmOverviewController(film: film), animated: true)
    }
}

extension FilmTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !viewModel.isSearch ? viewModel.films.count : viewModel.filteredFilms.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height/4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }

    func setupHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(bottomCloudImage)
        view.addSubview(searchBar)
        view.addSubview(tableHeaderView)
        view.addSubview(filmsTableView)
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
            bottomCloudImage.heightAnchor.constraint(equalTo: bottomCloudImage.widthAnchor, multiplier: 0.58)
        ])
    }
}
