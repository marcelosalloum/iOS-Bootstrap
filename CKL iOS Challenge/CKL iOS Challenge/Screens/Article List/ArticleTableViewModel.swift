//
//  ArticleTableViewModel.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import SwiftMessages
import EZCoreData


// MARK: - Protocol to comunicate from ViewModel o ViewController (MVVM)
protocol ArticleTableProtocol: class {
    func updateData(articles: [Article], endRefreshing: Bool)
    func displayError(error: Error, endRefreshing: Bool)
}


// MARK: - Used to order the Articles
enum ArticlesOrder: String {
    case id
    case authors
    case title
}


class ArticleTableViewModel: NSObject {
    
    // MARK: - Initial Set-up
    var articles: [Article] = []
    weak var delegate: ArticleTableProtocol?
    
    
    // MARK: - Filtering CoreData Results
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
        var predicate: NSPredicate? = nil
        if searchTerm.count > 0 {
            predicate = NSPredicate(format: "title CONTAINS[c] '\(searchTerm)' or authors CONTAINS[c] '\(searchTerm)'")
        }

        // Build NSSortDescriptor
        let sortDescriptor = NSSortDescriptor(key: articlesOrder.rawValue, ascending: true)

        // Read from the database
        do {
            articles = try Article.readAll(predicate: predicate, sortDescriptors: [sortDescriptor])
            self.delegate?.updateData(articles: articles, endRefreshing: true)
        } catch let e as NSError {
            print("ERROR: \(e.localizedDescription)")
        }
    }
    
    
    // MARK: - GET Articles from API
    func fetchAPIData() {
        APIHelper.getArticlesList { (apiCompletion) in
            switch apiCompletion {
            case .success(result: let articleList):
                Article.deleteAll(except: articleList, backgroundContext: EZCoreData.privateThreadContext, completion: { _ in
                    self.searchArticles(self.searchTerm, orderBy: self.articlesOrder, ascending: true)
                })
            case .failure(error: let error):
                self.delegate?.displayError(error: error, endRefreshing: true)
            }
        }
    }
    
    
    // MARK: - Update the read status in the CoreData
    func updateReadStatus(finalReadState: Bool, article: Article?, completion: @escaping ((EZCoreDataResult<Any>) -> ())) {
        guard let article = article else { return }
        article.wasRead = finalReadState
        let context = EZCoreData.shared.mainThredContext
        context.saveContextToStore(completion)
    }
    
    
    // MARK: - Animating Bottom Bar
    let bottomViewHeight: CGFloat = 44;
    var isShowingBottomView: Bool = false
    
    private func rectForVisibleBottomView(_ view: UIView) -> CGRect? {
        guard let superviewFrame = view.superview?.frame else { return nil }
        return CGRect(x: superviewFrame.minX,
                      y: superviewFrame.maxY - bottomViewHeight,
                      width: superviewFrame.maxX,
                      height: bottomViewHeight)
    }
    
    private func rectForHiddenBottomView(_ view: UIView) -> CGRect? {
        guard let superviewFrame = view.superview?.frame else { return nil }
        return CGRect(x: superviewFrame.minX,
                      y: superviewFrame.maxY,
                      width: superviewFrame.maxX,
                      height: bottomViewHeight)
    }
    
    func transitionBottomView(_ bottomView: UIView, shouldShow: Bool, layoutConstraint: NSLayoutConstraint, animated: Bool = true) {
        let constraintConstant: CGFloat = shouldShow ? 0 : -44
        
        layoutConstraint.constant = constraintConstant
        if animated {
            UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveLinear, animations: {
                bottomView.layoutIfNeeded()
            })
        }
    }
    
    func filterButtonClicked(_ bottomView: UIView, layoutConstraint: NSLayoutConstraint, animated: Bool = true) {
        transitionBottomView(bottomView, shouldShow: !isShowingBottomView, layoutConstraint: layoutConstraint, animated: animated)
        isShowingBottomView = !isShowingBottomView
    }
    
    
    // MARK: - Online/Offline modes
    @objc func phoneIsOnline(notification: Notification) {
        SwiftMessages.hide()
    }
    
    deinit {
        SwiftMessages.hide()
    }
    
    lazy var offlineMessageView: MessageView = {
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.warning)
        view.configureDropShadow()
        view.configureContent(title: "Warning".localized, body: "No Internet Connection".localized)
        view.layoutMarginAdditions = UIEdgeInsets(top: 2, left: 20, bottom: 2, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        return view
    }()
    
    @objc func phoneIsOffline(notification: Notification) {
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        SwiftMessages.show(config: config, view: offlineMessageView)
    }
}
