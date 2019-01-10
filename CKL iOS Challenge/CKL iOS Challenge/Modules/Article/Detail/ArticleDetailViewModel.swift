//
//  ArticleDetailViewModel.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit


protocol ArticleDetailProtocol: class {
    func updateRightBarButtonItem(_ barButtonItem: UIBarButtonItem?)
}


class ArticleDetailViewModel: NSObject {
    weak var delegate: ArticleDetailProtocol?
    
    var article: Article!
    
    func updateReadStatus(_ wasRead: Bool) {
        article.wasRead = wasRead
        let context = CKLCoreData.context
        Article.asyncSave(context, successCallback: {
            let newRightBarButtonItem = barButtonItem(for: article)
            self.delegate?.updateRightBarButtonItem(newRightBarButtonItem)
        })
    }
    
    func barButtonItem(for article: Article?) -> UIBarButtonItem? {
        guard let wasRead = article?.wasRead else { return nil }
        let buttonText = ArticleState.getText(wasRead: wasRead)
        return UIBarButtonItem(title: buttonText, style: .plain, target: self.delegate, action: #selector(ArticleDetailViewController.didSelectRightBarButtonItem(_: )))
    }
}
