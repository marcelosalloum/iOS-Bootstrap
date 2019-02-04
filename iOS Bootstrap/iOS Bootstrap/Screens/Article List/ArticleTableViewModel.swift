//
//  ArticleTableViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import EZCoreData

// MARK: - Protocol to comunicate from ViewModel o ViewController (MVVM)
protocol ArticleTableProtocol: class {
    func updateData(articles: [Article], endRefreshing: Bool)
    func displayError(error: Error, endRefreshing: Bool)
    func displayMessage(_ message: String)
}

// MARK: - Used to order the Articles
enum ArticlesOrder: String {
    case id
    case authors
    case title
}

class ArticleTableViewModel: NSObject, ListViewModelProtocol {

    // MARK: - Initial Set-up
    var articles: [Article] = []
    weak var delegate: ArticleTableProtocol?
    var ezCoreData: EZCoreData!

    override init() {
        super.init()

        // Observes offline mode
        NotificationCenter.default.addObserver(self,
            selector: #selector(ArticleTableViewModel.phoneIsOffline(notification:)),
            name: AppNotifications.PhoneIsOffline,
            object: nil)
    }

    deinit {
        // Deallocs observers
        NotificationCenter.default.removeObserver(self, name: AppNotifications.PhoneIsOffline, object: nil)
    }

    var articlesOrder: ArticlesOrder = .id {
        didSet {
            searchArticles(searchTerm, orderBy: articlesOrder, ascending: true)
        }
    }

    var searchTerm: String = "" {
        didSet {
            searchArticles(searchTerm, orderBy: articlesOrder, ascending: true)
        }
    }

    fileprivate func searchArticles(_ searchTerm: String = "", orderBy: ArticlesOrder = .id, ascending: Bool = true) {
        // Build NSPredicate
        var predicate: NSPredicate?
        if searchTerm.count > 0 {
            predicate = NSPredicate(format: "title CONTAINS[c] '\(searchTerm)' or authors CONTAINS[c] '\(searchTerm)'")
        }

        // Build NSSortDescriptor
        let sortDescriptor = NSSortDescriptor(key: articlesOrder.rawValue, ascending: true)

        // Read from the database
        do {
            articles = try Article.readAll(predicate: predicate,
                                           context: ezCoreData.mainThreadContext,
                                           sortDescriptors: [sortDescriptor])
            DispatchQueue.main.async {
                self.delegate?.updateData(articles: self.articles,
                    endRefreshing: true)
            }
        } catch let e as NSError {
            print("ERROR: \(e.localizedDescription)")
        }
    }

    // MARK: - GET Articles from API
    func fetchAPIData() {
        APIHelper.getArticlesList(ezCoreData.privateThreadContext) { (apiCompletion) in
            switch apiCompletion {
            case .success(result: let articleList):
                Article.deleteAll(except: articleList,
                                  backgroundContext: self.ezCoreData.privateThreadContext,
                                  completion: { (_) in
                    self.searchArticles(self.searchTerm, orderBy: self.articlesOrder, ascending: true)
                })
            case .failure(error: let error):
                DispatchQueue.main.async {
                    self.delegate?.displayError(error: error,
                        endRefreshing: true)
                }
            }
        }
    }

    // MARK: - Update the read status in the CoreData
    func updateReadStatus(finalReadState: Bool, article: Article?) {
        guard let article = article else { return }
        article.wasRead = finalReadState
        article.managedObjectContext?.saveContextToStore()
    }

    // MARK: - Animating Bottom Bar
    var isShowingBottomView: Bool = false

    func toggledContraintForFilterView(_ height: CGFloat) -> CGFloat {
        isShowingBottomView = !isShowingBottomView
        return isShowingBottomView ? 0 : -height
    }

    // MARK: - Offline modes
    @objc func phoneIsOffline(notification: Notification) {
        delegate?.displayMessage("No Internet Connection")
    }
}
