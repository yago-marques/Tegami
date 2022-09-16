//
//  MainScreenViewController.swift
//  GhibliAPP
//
//  Created by Gabriela Souza Batista on 16/09/22.
//

import UIKit

protocol MainScreenViewControllerDelegate: AnyObject {
    func updateTable()
}

class MainScreenViewController: UIViewController {
    lazy var viewModel = MainScreenViewModel(apiService: APICall(), delegate: self)
    lazy var filmTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Célula")
        
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(filmTable)
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task.detached {
            await self.viewModel.fetchFilms()
        }
    }
}

extension MainScreenViewController: UITableViewDelegate {
    
}
extension MainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filmTable.dequeueReusableCell(withIdentifier: "Célula", for: indexPath)
        cell.textLabel?.text = viewModel.films[indexPath.row].tmdb?.title
        return cell
    }
}

extension MainScreenViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            filmTable.topAnchor.constraint(equalTo: view.topAnchor),
            filmTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filmTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filmTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MainScreenViewController: MainScreenViewControllerDelegate {
    func updateTable() {
        filmTable.reloadData()
    }
}
