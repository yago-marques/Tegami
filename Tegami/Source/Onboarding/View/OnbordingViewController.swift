//
//  OnbordingViewController.swift
//  GhibliAPP
//
//  Created by Yago Marques on 08/09/22.
//

import UIKit

final class OnboardingViewController: UIViewController {

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.numberOfPages = 3
        control.currentPage = 1
        control.addTarget(self, action: #selector(pageControlSelectionAction), for: .valueChanged)
        control.pageIndicatorTintColor = .darkGray
        control.currentPageIndicatorTintColor = UIColor(named: "cGreen")

        return control
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Próximo", for: .normal)
        button.backgroundColor = UIColor(named: "cGreen")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toNext), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let height = view.safeAreaLayoutGuide.layoutFrame.height
        layout.itemSize = CGSize(width: view.frame.width, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let myCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myCollectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        myCollectionView.backgroundColor = .systemGray5
        myCollectionView.isPagingEnabled = true
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.showsHorizontalScrollIndicator = false

        return myCollectionView
    }()
    
    private let viewModel: OnboardingViewModeling

    init(viewModel: OnboardingViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.presentOnboardingIfNeeded()
    }
}

// MARK: - Objective-C Methods

@objc private extension OnboardingViewController {
    func pageControlSelectionAction() {
        navigateToCorrectScreen(at: pageControl.currentPage)
    }

    func toNext() {
        pageControl.currentPage += 1
        navigateToCorrectScreen(at: pageControl.currentPage)
        animateButton()
        viewModel.navigateToHomeIfNeeded(buttonTitle: nextButton.title(for: .normal))
    }
}

// MARK: - Private Methods

private extension OnboardingViewController {
    func navigateToCorrectScreen(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
    }
    
    func animateButton() {
        
        let hapticSoft = UIImpactFeedbackGenerator(style: .soft)
        let hapticRigid = UIImpactFeedbackGenerator(style: .rigid)

        hapticSoft.impactOccurred(intensity: 1.00)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            hapticRigid.impactOccurred(intensity: 1.00)
        }

        UIView.animate(withDuration: 0.1, animations: { }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.nextButton.layer.opacity = 0.5
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.nextButton.layer.opacity = 1
                })
            })
        })
    }
}

// MARK: - ViewCoding

extension OnboardingViewController: ViewCoding {
    func setupView() {
        view.backgroundColor = .systemBackground
    }

    func setupHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            nextButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor, multiplier: 0.2)
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        pageControl.currentPage = Int(scrollPos)
        viewModel.setupTitle(at: pageControl.currentPage)
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell else {
            return UICollectionViewCell()
        }
        let model = viewModel.getModel(at: indexPath.row)
        cell.cellOption = indexPath.row
        cell.setup(with: model)
        return cell
    }
}

// MARK: - OnboardginViewModelDelegate

extension OnboardingViewController: OnboardingViewModelDelegate {
    func setup(buttonTitle: String) {
        UIView.transition(
            with: nextButton,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.nextButton.setTitle(buttonTitle, for: .normal)
            }
        )
    }
            
    func showOnboarding() {
        buildLayout()
    }
    
    func showMainScreen() {
        navigationController?.pushViewController(MainScreenViewController(), animated: true)
    }
    
    func displayScreen(at index: Int) {
        pageControl.currentPage = index
        navigateToCorrectScreen(at: index)
    }
}
