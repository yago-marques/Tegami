//
//  MainScreenViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 15/09/22.
//

import UIKit

final class MainScreenViewController: UIViewController {

    private let viewModel: MainScreenViewModel

    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("error MainScreenViewController")
    }

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

        return table
    }()

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

extension MainScreenViewController: MainScreenViewModelDelegate {
    func reloadTable() {
        filmsTableView.reloadData()
    }
}

extension MainScreenViewController: UITableViewDelegate { }

extension MainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.films.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height/4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCardCell", for: indexPath) as! FilmCardCell
        cell.film = viewModel.films[indexPath.row]

        return cell
    }
}

extension MainScreenViewController: ViewCoding {
    func setupView() {
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
    }

    func setupHierarchy() {
        view.addSubview(filmsTableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            filmsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filmsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filmsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filmsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
