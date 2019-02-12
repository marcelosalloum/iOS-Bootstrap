//
//  NewsTableViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

class InnerCollectionViewModel: NSObject {

    // MARK: - Injected Dependencies
    weak var coordinator: NewsInteractionProtocol?

    var articlesTag: Tag! {
        didSet {
            guard let articles = articlesTag.articles?.allObjects as? [Article] else { return }
            self.articles = articles
        }
    }

    var articles: [Article] = []
}

// MARK: - User Selected index path
extension InnerCollectionViewModel: ListViewModelProtocol {
    func userDidSelect(indexPath: IndexPath) {
        let article = type(of: self).getObject(from: articles, with: indexPath)
        coordinator?.userDidSelectArticle(article)
    }
}
