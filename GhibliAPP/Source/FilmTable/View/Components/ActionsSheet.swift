//
//  ActionsSheet.swift
//  GhibliAPP
//
//  Created by Yago Marques on 23/09/22.
//

import UIKit

final class ActionSheet: UIViewController {

    weak var delegate: ActionSheetDelegate?

    init(delegate: ActionSheetDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("error ActionSheet")
    }

    var film: FilmModel = FilmModel(ghibli: nil, tmdb: nil) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let backdropPath = self?.film.tmdb?.backdropPath {
                    self?.titleLabel.text = self?.film.tmdb?.title
                    let imageUrl = URL(string: UrlEnum.baseImage.rawValue.appending(backdropPath))!
                    self?.filmBackdropView.downloaded(from: imageUrl)
                }
            }
        }
    }

    var contentOfRowAt: [(title: String, image: String)] = []

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center

        return label
    }()

    private let textShape: UIView = {
        let shape = UIView(frame: .zero)
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.backgroundColor = .systemGray5
        shape.layer.opacity = 0.6
        shape.layer.cornerCurve = .circular
        shape.layer.cornerRadius = 10

        return shape
    }()

    private let filmBackdropView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemGray5

        return image
    }()

    private lazy var actionsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(ActionSheetCell.self, forCellReuseIdentifier: "ActionSheetCell")
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .systemGray5
        table.allowsSelection = true
        table.isUserInteractionEnabled = true
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        buildLayout()
    }

}

extension ActionSheet: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentOfRowAt.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = actionsTable.dequeueReusableCell(withIdentifier: "ActionSheetCell", for: indexPath) as? ActionSheetCell else {
            return UITableViewCell(frame: .zero)
        }
        cell.actionData = self.contentOfRowAt[indexPath.row]

        return cell
    }
}

extension ActionSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ActionSheetCell
        DispatchQueue.main.async { [weak self] in
            if
                let delegate = self?.delegate,
                let id = self?.film.ghibli?.id,
                let label = cell.actionLabel.text
            {
                switch label {
                case "Adicionar na minha lista":
                    delegate.addNewFilmToList(id: id)
                case "Remover da minha lista":
                    delegate.removeFilmOfList(id: id)
                case "Tornar o primeiro da lista":
                    delegate.turnFirstOfList(id: id)
                default:
                    print("error not expected")
                }

                self?.dismiss(animated: true)
            }
        }
    }
}

extension ActionSheet: ViewCoding {
    func setupView() {
        view.backgroundColor = .systemGray5
    }

    func setupHierarchy() {
        view.addSubview(filmBackdropView)
        view.addSubview(textShape)
        view.addSubview(titleLabel)
        view.addSubview(actionsTable)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            filmBackdropView.topAnchor.constraint(equalTo: view.topAnchor),
            filmBackdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filmBackdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filmBackdropView.heightAnchor.constraint(equalTo: filmBackdropView.widthAnchor, multiplier: 0.565),

            textShape.heightAnchor.constraint(equalTo: filmBackdropView.heightAnchor, multiplier: 0.7),
            textShape.widthAnchor.constraint(equalTo: filmBackdropView.widthAnchor, multiplier: 0.7),
            textShape.centerXAnchor.constraint(equalTo: filmBackdropView.centerXAnchor),
            textShape.centerYAnchor.constraint(equalTo: filmBackdropView.centerYAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: textShape.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: textShape.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: textShape.widthAnchor, multiplier: 0.9),

            actionsTable.topAnchor.constraint(equalTo: filmBackdropView.bottomAnchor),
            actionsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionsTable.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])

    }
}
