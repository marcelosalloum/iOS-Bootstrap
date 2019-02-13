//
//  NewsCollectionCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

// MARK: - Coordinator Mandatory Implementation
class NewsCollectionCoordinator: Coordinator {
    // MARK: - Init
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData

    init(presenter: UINavigationController, ezCoreData: EZCoreData) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
    }

    // MARK: - Start
    private weak var newsCollectionViewController: NewsCollectionViewController?
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

// MARK: - NewsInteractionProtocol
extension NewsCollectionCoordinator: NewsInteractionProtocol {
    func userDidSelectArticle(_ selectedArticle: Article) {
        let newsDetailCoordinator = NewsDetailCoordinator(presenter: presenter, article: selectedArticle)
        startCoordinator(newsDetailCoordinator)
    }
}
