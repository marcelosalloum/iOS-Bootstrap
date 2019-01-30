//
//  ArticleTableCoordinator.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//


import UIKit


protocol ArticleTableViewControllerDelegate: class {
    func articleTableViewControllerDidSelectArticle(_ selectedArticle: Article)
}


class ArticleTableCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var articleTableViewController: ArticleTableViewController?
    private var articleDetailCoordinator: ArticleDetailCoordinator?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        guard let articleTableViewController = ArticleTableViewController.fromStoryboard("Main") else { return }
        articleTableViewController.title = "News"
        presenter.pushViewController(articleTableViewController, animated: true)
        articleTableViewController.coordinator = self
        self.articleTableViewController = articleTableViewController
    }
}


extension ArticleTableCoordinator: ArticleTableViewControllerDelegate {
    func articleTableViewControllerDidSelectArticle(_ selectedArticle: Article) {
        let articleDetailCoordinator = ArticleDetailCoordinator(presenter: presenter, article: selectedArticle)
        articleDetailCoordinator.start()
        self.articleDetailCoordinator = articleDetailCoordinator
    }
}
