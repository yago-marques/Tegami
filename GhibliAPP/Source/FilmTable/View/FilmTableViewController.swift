//
//  MainScreenViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 15/09/22.
//

import UIKit

final class FilmTableViewController: UIViewController {

    private let viewModel: FilmTableViewModel

    private let backgroundImage: UIImageView = {
        let background = UIImageView(frame: .zero)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.image = UIImage(named: "Elementos/fundoA-list")
        background.contentMode = .scaleAspectFill

        return background
    }()

    lazy var bottomCloudImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Elementos/aCloud")
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
        table.allowsSelection = false
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false

        return table
    }()

    init(viewModel: FilmTableViewModel) {
        self.viewModel = viewModel
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    @objc func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }
}

extension FilmTableViewController: UITableViewDelegate { }

extension FilmTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !viewModel.isSearch ? viewModel.films.count : viewModel.filteredFilms.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height/4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCardCell", for: indexPath) as! FilmCardCell
        cell.film = !viewModel.isSearch ? viewModel.films[indexPath.row] : viewModel.filteredFilms[indexPath.row]

        return cell
    }
}

extension FilmTableViewController: ViewCoding {
    func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        viewModel.delegate = self
        let tapGestureToHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureToHideKeyboard)
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
