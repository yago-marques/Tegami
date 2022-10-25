//
//  ActionSheetCell.swift
//  GhibliAPP
//
//  Created by Yago Marques on 24/09/22.
//

import UIKit

final class ActionSheetCell: UITableViewCell {

    var actionData: (title: String, image: String) = ("", "") {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let (title, image) = self?.actionData {
                    self?.actionLabel.text = title
                    self?.actionImage.image = UIImage(systemName: image)
                }
            }
        }
    }

    private(set) var actionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let actionImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemGray

        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("error FilmCardCell")
    }

}

extension ActionSheetCell: ViewCoding {
    func setupView() {
        self.backgroundColor = .systemGray6
        self.selectionStyle = .none
    }

    func setupHierarchy() {
        self.addSubview(actionLabel)
        self.addSubview(actionImage)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            actionImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            actionImage.widthAnchor.constraint(equalTo: actionImage.heightAnchor),
            actionImage.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 3),
            actionImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            actionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: actionImage.trailingAnchor, multiplier: 2),
            actionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            actionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
