//
//  ArticleTableViewModel.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import SwiftMessages


protocol ArticleTableProtocol: class {
    func updateData(articles: [Article], endRefreshing: Bool)
    func displayError(error: Error, endRefreshing: Bool)
}

enum ArticlesOrder: String {
    case null
    case id
    case authors
    case title
}

class ArticleTableViewModel: NSObject {
    
    var articles: [Article] = []
    weak var delegate: ArticleTableProtocol?
    
    fileprivate var _articlesOrder: ArticlesOrder = .id
    var articlesOrder: ArticlesOrder = .id {
        didSet {
            _articlesOrder = articlesOrder
            filterArticles(_searchTerm, orderBy: _articlesOrder, ascending: true)
        }
    }
    
    fileprivate var _searchTerm: String = ""
    var searchTerm: String = "" {
        didSet {
            _searchTerm = searchTerm
            filterArticles(_searchTerm, orderBy: _articlesOrder, ascending: true)
        }
    }

    // GET API Data
    func fetchAPIData() {
        RestAPI.getArticlesList { (apiCompletion) in
            switch apiCompletion {
            case .success(objectList: _):
                self.filterArticles(self.searchTerm, orderBy: self.articlesOrder, ascending: true)
            case .failure(error: let error):
                self.delegate?.displayError(error: error, endRefreshing: true)
            }
            
        }
    }
    
    // Get CoreData stored data
    func filterArticles(_ searchTerm: String? = nil, orderBy: ArticlesOrder = .null, ascending: Bool = true) {
        // Sorting - ORDER BY
        let sortAttribute = (orderBy == .null) ? _articlesOrder : orderBy
        _articlesOrder = sortAttribute
        let sortDescriptor = NSSortDescriptor(key: _articlesOrder.rawValue, ascending: true)
        
        // Filtering - WHERE
        var predicate: NSPredicate? = nil
        var searchText: String = ""
        if let searchTerm = searchTerm {
            _searchTerm = searchTerm
        }
        searchText = _searchTerm
        if searchText.count > 0 {
            predicate = NSPredicate(format: "title CONTAINS[c] '\(searchText)' or authors CONTAINS[c] '\(searchText)'")
        }

        do {
            let articles = try Article.readAll(CKLCoreData.context, predicate: predicate, sortDescriptors: [sortDescriptor])
            self.articles = articles
            self.delegate?.updateData(articles: articles, endRefreshing: true)
        } catch let e as NSError {
            print("ERROR: \(e.localizedDescription)")
        }
    }
    
    // Update the read status in the CoreData (this is currently only saved locally)
    func updateReadStatus(finalReadState: Bool, article: Article?, completion: ((AwesomeDataResult<Article>) -> ())) {
        guard let article = article else { return }
        article.wasRead = finalReadState
        let context = CKLCoreData.context
        Article.asyncSave(context, completion: completion)
    }
    
    // MARK: Animating Bottom Bar
    let bottomViewHeight: CGFloat = 44;
    var isShowingBottomView: Bool = false
    
    func rectForVisibleBottomView(_ view: UIView) -> CGRect? {
        guard let superviewFrame = view.superview?.frame else { return nil }
        return CGRect(x: superviewFrame.minX,
                      y: superviewFrame.maxY - bottomViewHeight,
                      width: superviewFrame.maxX,
                      height: bottomViewHeight)
    }
    
    func rectForHiddenBottomView(_ view: UIView) -> CGRect? {
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
