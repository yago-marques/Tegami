//
//  FilmOverviewController.swift
//  GhibliAPP
//
//  Created by Gabriela Souza Batista on 22/09/22.
//
import UIKit

final class FilmOverviewController: UIViewController {

    weak var tableViewModel: FilmTableViewModel?
    private var film: FilmModel
    private var indexPath: Int
    private var closeActions: Bool = false {
        didSet {
            self.popView()
        }
    }
    
    init(
        film: FilmModel,
        tableViewModel: FilmTableViewModel,
        indexPath: Int
    ) {
        self.tableViewModel = tableViewModel
        self.film = film
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundView: BackgroundView = {
        let background = BackgroundView()
        background.translatesAutoresizingMaskIntoConstraints = false
        
        return background
    }()
    
    private lazy var backdropPathView : BackdropPathView = {
        let image = BackdropPathView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.film = self.film
        
        return image
    }()
    
    private lazy var posterPathView : PosterPathView = {
        let imagePoster = PosterPathView()
        imagePoster.translatesAutoresizingMaskIntoConstraints = false
        imagePoster.film = self.film
        
        return imagePoster
    }()
    
    private lazy var descriptionFilmView : DescriptionFilmView = {
        let description = DescriptionFilmView()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.filmTeste = self.film

        return description
    }()

    private lazy var optionsMenu: UIImageView = {
        var image = UIImageView(frame: .zero)
        image.image = UIImage(systemName: "ellipsis.circle.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.TapPresshandler))
        image.addGestureRecognizer(tap)

        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildLayout()
    }

    @objc func TapPresshandler(_ sender: UITapGestureRecognizer) {
        guard let viewModel = self.tableViewModel else { return }
        let mySheet = ActionSheet(delegate: viewModel, overViewDelegate: self)
        mySheet.film = self.film

        if !viewModel.isSearch {
            switch viewModel.tableState {
            case .all:
                mySheet.contentOfRowAt = viewModel.getActions(state: .all)
            case .toWatch:
                if indexPath == 0 {
                    mySheet.contentOfRowAt = viewModel.getActions(state: .toWatch, isFirst: true)
                } else {
                    mySheet.contentOfRowAt = viewModel.getActions(state: .toWatch)
                }
            }
        } else {
            guard
                let id = film.ghibli?.id,
                let content = viewModel.findFilmOnList(id: id)
            else { return }

            mySheet.contentOfRowAt = content
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

extension FilmOverviewController: OverViewDelegate {
    func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FilmOverviewController: ViewCoding {
    func setupView() {
        view.backgroundColor = .white
        UINavigationBar.appearance().tintColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(descriptionFilmView)
        view.addSubview(backdropPathView)
        view.addSubview(posterPathView)
        view.addSubview(optionsMenu)
        
        view.sendSubviewToBack(backgroundView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            descriptionFilmView.topAnchor.constraint(equalTo: backdropPathView.bottomAnchor),
            descriptionFilmView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            descriptionFilmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionFilmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            optionsMenu.topAnchor.constraint(equalToSystemSpacingBelow: descriptionFilmView.topAnchor, multiplier: 2),
            optionsMenu.trailingAnchor.constraint(equalTo: descriptionFilmView.cardView.trailingAnchor, constant: -10),
            optionsMenu.widthAnchor.constraint(equalTo: descriptionFilmView.widthAnchor, multiplier: 0.1),
            optionsMenu.heightAnchor.constraint(equalTo: optionsMenu.widthAnchor),
            
            backdropPathView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backdropPathView.widthAnchor.constraint(equalTo: view.widthAnchor),
            backdropPathView.heightAnchor.constraint(equalTo: backdropPathView.widthAnchor, multiplier: 0.5),
            
            posterPathView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            posterPathView.widthAnchor.constraint(equalTo: view.widthAnchor),
            posterPathView.heightAnchor.constraint(equalTo: posterPathView.widthAnchor, multiplier: 0.5)
        ])
    }
}
