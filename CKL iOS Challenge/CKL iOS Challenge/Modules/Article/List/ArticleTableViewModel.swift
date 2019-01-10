//
//  ArticleTableViewModel.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit


protocol ArticleTableProtocol: class {
    func updateData(articles: [Article], endRefreshing: Bool)
    func displayError(error: Error, endRefreshing: Bool)
}

class ArticleTableViewModel: NSObject {
    
    var articles: [Article] = []
    weak var delegate: ArticleTableProtocol?

    // GET API Data
    func fetchAPIData() {
        RestAPI.getArticlesList({ (fetchedArticles) in
            self.articles = fetchedArticles
            self.delegate?.updateData(articles: fetchedArticles, endRefreshing: true)
        }) {  (error) in
            self.delegate?.displayError(error: error, endRefreshing: true)
        }
    }
    
    // Get CoreData stored data
    func setupInitialData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        Article.asyncAllInContext(context, success: {(coreDataArticles) in
            self.articles = coreDataArticles
            self.delegate?.updateData(articles: coreDataArticles, endRefreshing: false)
        })
    }
    
    // Update the read status in the CoreData (this is currently only saved locally)
    func updateReadStatus(finalReadState: Bool, article: Article?, success: (() -> ())) {
        guard let article = article else { return }
        article.wasRead = finalReadState
        let context = CKLCoreData.context
        Article.asyncSave(context, successCallback: success)
    }
}
