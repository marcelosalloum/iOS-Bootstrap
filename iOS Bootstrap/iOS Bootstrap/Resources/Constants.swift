//
//  States.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

struct Constants {
    static let flurryAPIKey: String = "WMFS8685YKR8J5Z4XQ5V"
    static let databaseName: String = "iOS_Bootstrap"
    static let idKey: String = "id"
}

struct ArticleState {
    static let markRead: String = "Mark as read"
    static let markUnread: String = "Mark as unread"
    static func getText(initialReadStatus wasRead: Bool) -> String {
        if wasRead {
            return ArticleState.markUnread
        }
        return ArticleState.markRead
    }
}
