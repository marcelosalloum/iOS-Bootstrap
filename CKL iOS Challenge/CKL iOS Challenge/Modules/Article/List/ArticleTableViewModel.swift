//
//  ArticleTableViewModel.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit


protocol ArticleTableDelegate: class {
    // The following command (ie, method) must be obeyed by any
    // underling (ie, delegate) of the older sibling.
    func updateData(articles: [Article], endRefreshing: Bool)
    func displayError(error: Error, endRefreshing: Bool)
}

class ArticleTableViewModel: NSObject {
    
    var articles: [Article] = []
    weak var delegate: ArticleTableDelegate?

    func fetchAPIData() {
        RestAPI.getArticlesList({ (fetchedArticles) in
            self.articles = fetchedArticles
            self.delegate?.updateData(articles: fetchedArticles, endRefreshing: true)
        }) {  (error) in
            self.delegate?.displayError(error: error, endRefreshing: true)
        }
    }
    
    func setupInitialData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        Article.asyncAllInContext(context, success: {(coreDataArticles) in
            self.articles = coreDataArticles
            self.delegate?.updateData(articles: coreDataArticles, endRefreshing: false)
        })
    }
}
