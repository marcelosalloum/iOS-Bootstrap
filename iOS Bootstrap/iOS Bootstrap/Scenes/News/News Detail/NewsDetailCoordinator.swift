//
//  NewsDetailCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

// MARK: - Coordinator Mandatory Implementation
class NewsDetailCoordinator: Coordinator {
    // MARK: - Init
    private let presenter: UINavigationController
    private var article: Article

    init(presenter: UINavigationController, article: Article) {
        self.presenter = presenter
        self.article = article
    }

    // MARK: - Start
    private weak var newsDetailViewController: NewsDetailViewController?
    override func start() {
        // View Controller:
        guard let newsDetailViewController = NewsDetailViewController.fromStoryboard(.table) else { return }
        newsDetailViewController.title = "📚"
        // View Model:
        let viewModel = NewsDetailViewModel()
        viewModel.article = article
        viewModel.delegate = newsDetailViewController
        newsDetailViewController.viewModel = viewModel
        // Present View Controller:
        presenter.pushViewController(newsDetailViewController, animated: true)
        setDeallocallable(with: newsDetailViewController)
        self.newsDetailViewController = newsDetailViewController
    }
}
