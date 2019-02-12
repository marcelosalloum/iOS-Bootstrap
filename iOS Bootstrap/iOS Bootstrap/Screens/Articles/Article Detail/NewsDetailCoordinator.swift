//
//  NewsDetailCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

class NewsDetailCoordinator: Coordinator {
    private let presenter: UINavigationController
    private weak var newsDetailViewController: NewsDetailViewController?
    private var article: Article

    init(presenter: UINavigationController, article: Article) {
        self.presenter = presenter
        self.article = article
    }

    override func start() {
        // View Controller:
        guard let newsDetailViewController = NewsDetailViewController.fromStoryboard(.news) else { return }
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
