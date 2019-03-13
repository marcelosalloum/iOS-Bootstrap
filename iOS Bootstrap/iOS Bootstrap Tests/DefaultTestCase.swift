//
//  iOS_Bootstrap_Tests.swift
//  iOS Bootstrap Tests
//
//  Created by Marcelo Salloum dos Santos on 24/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import XCTest
import CoreData
@testable import iOS_Bootstrap
@testable import EZCoreData

// MARK: - Mocking Core Data:
class DefaultTestCase: XCTestCase {

    override func setUp() {
        EZCoreData.shared.setupInMemoryPersistence("Model")
//        eraseAllArticles()
//        importAllArticles()
    }

    var context: NSManagedObjectContext {
        return EZCoreData.mainThreadContext
    }

    var backgroundContext: NSManagedObjectContext {
        return EZCoreData.privateThreadContext
    }

//    public func eraseAllArticles() {
//        try? Article.deleteAll(context: context)
//        let countZero = try? Article.count(context: context)
//        XCTAssertEqual(countZero, 0)
//    }
//
//    public func importAllArticles() {
//        _ = try? Article.importList(mockArticleListResponseJSON, idKey: "id", shouldSave: true, context: context)
//        let countSix = try? Article.count(context: context)
//        XCTAssertEqual(countSix, mockArticleListResponseJSON.count)
//    }
}
