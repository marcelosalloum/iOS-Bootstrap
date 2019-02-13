//
//  NewsTableCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

// MARK: - Coordinator Mandatory Implementation
class NewsTableCoordinator: Coordinator {
    // MARK: - Init
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData!

    init(presenter: UINavigationController, ezCoreData: EZCoreData) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
    }

    // MARK: - Start
    private weak var newsTableViewController: NewsTableViewController?
    override func start() {
        // View Controller:
        guard let newsTableViewController = NewsTableViewController.fromStoryboard(.table) else { return }
        setDeallocallable(with: newsTableViewController)

        // View Model:
        let viewModel = NewsTableViewModel()
        newsTableViewController.viewModel = viewModel
        viewModel.coordinator = self
        viewModel.delegate = newsTableViewController
        viewModel.ezCoreData = ezCoreData

        // Present View Controller:
        presenter.pushViewController(newsTableViewController, animated: true)
        self.newsTableViewController = newsTableViewController
    }
}

// MARK: - Article Interaction Protocol
extension NewsTableCoordinator: NewsInteractionProtocol {
    func userDidSelectArticle(_ selectedArticle: Article) {
        let newsDetailCoordinator = NewsDetailCoordinator(presenter: presenter, article: selectedArticle)
        startCoordinator(newsDetailCoordinator)
    }
}
