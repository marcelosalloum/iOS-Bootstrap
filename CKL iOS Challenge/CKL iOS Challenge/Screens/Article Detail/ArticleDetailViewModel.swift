//
//  ArticleDetailViewModel.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData


protocol ArticleDetailProtocol: class {
    func updateRightBarButtonItem(_ barButtonItem: UIBarButtonItem?)
}


class ArticleDetailViewModel: NSObject {
    weak var delegate: ArticleDetailProtocol?
    
    var article: Article!
    
    func updateReadStatus(_ finalReadState: Bool) {
        article.wasRead = finalReadState
        article.managedObjectContext?.saveContextToStore()  // Sync task because the user is waiting for the result
        let newRightBarButtonItem = barButtonItem(for: article)
        self.delegate?.updateRightBarButtonItem(newRightBarButtonItem)
    }
    
    func barButtonItem(for article: Article?) -> UIBarButtonItem? {
        guard let wasRead = article?.wasRead else { return nil }
        let buttonText = ArticleState.getText(initialReadStatus: wasRead)
        return UIBarButtonItem(title: buttonText, style: .plain, target: self.delegate, action: #selector(ArticleDetailViewController.didSelectRightBarButtonItem(_: )))
    }
}
