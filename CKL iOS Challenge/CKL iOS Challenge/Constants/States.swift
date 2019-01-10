//
//  States.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

struct ArticleState {
    static let markRead: String = "Mark as read"
    static let markUnread: String = "Mark as unread"
    static func getText(wasRead: Bool) -> String {
        if wasRead {
            return ArticleState.markUnread
        }
        return ArticleState.markRead
    }
}
