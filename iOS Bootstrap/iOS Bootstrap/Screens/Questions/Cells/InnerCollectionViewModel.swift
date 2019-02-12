//
//  NewsTableViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

// MARK: - Protocol to comunicate from ViewModel o ViewController (MVVM)
//protocol NewsCollectionProtocol: class {
//    func updateData(tags: [Tag], endRefreshing: Bool)
//    func displayError(error: Error, endRefreshing: Bool)
//    func displayMessage(_ message: String)
//}

class InnerCollectionViewModel: NSObject, ListViewModelProtocol {

    // MARK: - Initial Set-up
    weak var coordinator: NewsTableViewControllerDelegate?

    var articlesTag: Tag! {
        didSet {
            guard let articles = articlesTag.articles?.allObjects as? [Article] else { return }
            self.articles = articles
        }
    }

    var articles: [Article] = []

//    weak var delegate: NewsCollectionProtocol?
//    weak var coordinator: NewsTableViewControllerDelegate?

    func userDidSelect(indexPath: IndexPath) {
        let article = type(of: self).getObject(from: articles, with: indexPath)
        coordinator?.newsTableViewControllerDidSelectArticle(article)
    }
}
