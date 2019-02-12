//
//  NewsCollectionCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

protocol NewsCollectionViewControllerDelegate: class {
    func userDidClickLogin()
    func userDidClickSignUp()
}

class NewsCollectionCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData

    private weak var newsCollectionViewController: NewsCollectionViewController?

    init(presenter: UINavigationController, ezCoreData: EZCoreData) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
    }

    override func start() {
        // View Model
        let viewModel = NewsCollectionViewModel()
        viewModel.ezCoreData = ezCoreData
        viewModel.coordinator = self

        // View Controller:
        guard let newsCollectionViewController =
            NewsCollectionViewController.fromStoryboard(.collection) else { return }
        newsCollectionViewController.viewModel = viewModel
        viewModel.delegate = newsCollectionViewController

        // Present View Controller:
        presenter.pushViewController(newsCollectionViewController, animated: true)
        setDeallocallable(with: newsCollectionViewController)
        self.newsCollectionViewController = newsCollectionViewController
    }
}

// MARK: - ArticleInteractionProtocol
extension NewsCollectionCoordinator: ArticleInteractionProtocol {
    func userDidSelectArticle(_ selectedArticle: Article) {
        let newsDetailCoordinator = NewsDetailCoordinator(presenter: presenter, article: selectedArticle)
        startCoordinator(newsDetailCoordinator)
    }
}
