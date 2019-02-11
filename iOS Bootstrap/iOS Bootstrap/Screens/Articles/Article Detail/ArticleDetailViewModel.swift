//
//  ArticleDetailViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

protocol ArticleDetailProtocol: class {
    func resetRightBarButtonItem(withText buttonText: String)
}

class ArticleDetailViewModel: NSObject {

    // MARK: - Properties
    weak var delegate: ArticleDetailProtocol?

    var article: Article! {
        didSet {
            updateReadStatus(true)
        }
    }

    // MARK: - From the VC:
    func userSwitchedReadStatus() {
        updateReadStatus(!article.wasRead)
    }

    fileprivate func updateReadStatus(_ finalReadState: Bool) {
        article.wasRead = finalReadState
        article.managedObjectContext?.saveContextToStore() // Sync task because the user is waiting for the result
        let buttonText = ArticleState.getText(initialReadStatus: article.wasRead)
        self.delegate?.resetRightBarButtonItem(withText: buttonText)
    }
}
