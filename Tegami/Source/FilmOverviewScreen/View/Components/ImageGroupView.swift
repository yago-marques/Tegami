//
//  ImageGroupView.swift
//  GhibliAPP
//
//  Created by Stephane Girão Linhares on 26/09/22.
//

import UIKit

final class ImageGroupView: UIView {
    
    var film: FilmModel = FilmModel(ghibli: nil, tmdb: nil) {
        didSet {
            DispatchQueue.main.async {
                self.titleLabel.text = self.film.tmdb?.title
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        return label
    }()
    
    init () {
        super.init(frame: .zero)
        
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageGroupView: ViewCoding {
    func setupView() {
        
    }
    
    func setupHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }
    
}
