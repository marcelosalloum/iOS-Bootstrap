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
        RestAPI.getArticlesList({ (_) in
            self.filterArticles(self.searchTerm, orderBy: self.articlesOrder, ascending: true)
        }) {  (error) in
            self.delegate?.displayError(error: error, endRefreshing: true)
        }
    }
    
    // Get CoreData stored data
    func setupInitialData(orderBy: ArticlesOrder = .null, endRefefreshing: Bool = true) {
        let sortAttribute = (orderBy == .null) ? _articlesOrder : orderBy
        _articlesOrder = sortAttribute
        
        let sortDescriptor = NSSortDescriptor(key: orderBy.rawValue, ascending: true)
        Article.asyncReadObjects(CKLCoreData.context, sortDescriptors: [sortDescriptor], success: { (coreDataArticles) in
            self.articles = coreDataArticles
            self.delegate?.updateData(articles: coreDataArticles, endRefreshing: endRefefreshing)
        })
    }
    
    func filterArticles(_ searchTerm: String?, orderBy: ArticlesOrder = .null, ascending: Bool = true) {
        // Sorting - ORDER BY
        let sortAttribute = (orderBy == .null) ? _articlesOrder : orderBy
        _articlesOrder = sortAttribute
        let sortDescriptor = NSSortDescriptor(key: orderBy.rawValue, ascending: true)
        
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
            let articles = try Article.readObjects(CKLCoreData.context, predicate: predicate, sortDescriptors: [sortDescriptor])
            self.articles = articles
            self.delegate?.updateData(articles: articles, endRefreshing: true)
        } catch let e as NSError {
            print("ERROR: \(e.localizedDescription)")
        }
    }
    
    // Update the read status in the CoreData (this is currently only saved locally)
    func updateReadStatus(finalReadState: Bool, article: Article?, success: (() -> ())) {
        guard let article = article else { return }
        article.wasRead = finalReadState
        let context = CKLCoreData.context
        Article.asyncSave(context, successCallback: success)
    }
    
    // MARK: Animating Botton Bar
    let bottomViewHeight: CGFloat = 44;
    var isShowingBottomView: Bool = false
    
    func showBottomViewRect(_ view: UIView) -> CGRect? {
        guard let superviewFrame = view.superview?.frame else { return nil }
        return CGRect(x: superviewFrame.minX,
                      y: superviewFrame.maxY - bottomViewHeight,
                      width: superviewFrame.maxX,
                      height: bottomViewHeight)
    }
    
    func hideBottomViewRect(_ view: UIView) -> CGRect? {
        guard let superviewFrame = view.superview?.frame else { return nil }
        return CGRect(x: superviewFrame.minX,
                      y: superviewFrame.maxY,
                      width: superviewFrame.maxX,
                      height: bottomViewHeight)
    }
    
    func transitionBottomViewToState(_ bottomView: UIView, shouldShow: Bool, animated: Bool = true) {
        let finalRect: CGRect
        if shouldShow {
            guard let rect = showBottomViewRect(bottomView) else { return }
            finalRect = rect
        } else {
            guard let rect = hideBottomViewRect(bottomView) else { return }
            finalRect = rect
        }
        
        if !animated {
            bottomView.frame = finalRect
            return
        }
        UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveLinear, animations: {
            bottomView.frame = finalRect
        })
    }
    
    func filterButtonClicked(_ bottomView: UIView, animated: Bool = true) {
        transitionBottomViewToState(bottomView, shouldShow: !isShowingBottomView)
        isShowingBottomView = !isShowingBottomView
    }
}
