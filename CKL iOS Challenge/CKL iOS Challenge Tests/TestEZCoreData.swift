//
//  TestEZCoreData.swift
//  CKL iOS Challenge Tests
//
//  Created by Marcelo Salloum dos Santos on 21/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import XCTest
import UIKit
import CoreData
@testable import CKL_iOS_Challenge


// MARK: - Mocking Core Data:
class TestEZCoreData: XCTestCase {

    let myID = "123456789"

    static let mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: Constants.databaseName)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    static let context: NSManagedObjectContext = {
        return mockPersistantContainer.viewContext
    }()
    
    var context: NSManagedObjectContext {
        return TestEZCoreData.context
    }
    
    func purgeDatabase() {
        do {
            for article in try Article.readAll(context: context) {
                try article.delete(shouldSave: false, context: context)
            }
            for tag in try Tag.readAll(context: context) {
                try tag.delete(shouldSave: false, context: context)
            }
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}


// MARK: - Test Methods
extension TestEZCoreData {
    
    override func setUp() {
        _ = TestEZCoreData.mockPersistantContainer
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // Mark: - Test Single Create
    func testArticleCreation() {
        do {
            // Test Count and Save methods
            let initialCount = try Article.count(context: context)
            _ = Article.getOrCreate(attribute: "id", value: myID, context: context)
            try context.save()
            let countPP = try Article.count(context: context)
            XCTAssertEqual(initialCount + 1, countPP)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    // Mark: - Test Delete
    func testArticleDeletion() {
        do {
            // Test Count and Save methods
            let initialCount = try Article.count(context: context)
            print(initialCount)
            let article = Article.getOrCreate(attribute: "id", value: myID, context: context)
            try context.save()
            let countPP = try Article.count(context: context)
            print(countPP)
            XCTAssertEqual(initialCount + 1, countPP)

            // Test Delete and Count Methods
            try article?.delete(context: context)
            let finalCount = try Article.count(context: context)
            print(finalCount)
            XCTAssertEqual(countPP - 1, finalCount)
            XCTAssertEqual(initialCount, finalCount)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func testDatabasePurge() {
        purgeDatabase()
        let countZero = try? Article.count(context: context)
        XCTAssertEqual(countZero, 0)
    }
    
    
    // Mark: - Test Import
    func testImportSync() {
        purgeDatabase()
        let countZero = try? Article.count(context: context)
        XCTAssertEqual(countZero, 0)
        
        _ = try? Article.importList(mockArticleListResponseJSON, idKey: "id", shouldSave: true, context: context)
        let countSix = try? Article.count(context: context)
        XCTAssertEqual(countSix, 6)
    }
    
    func testImportAsync() {
        purgeDatabase()
        let countZero = try? Article.count(context: context)
        XCTAssertEqual(countZero, 0)
        
        Article.importList(mockArticleListResponseJSON, idKey: "id", backgroundContext: context) { _ in
            let countSix = try? Article.count(context: self.context)
            XCTAssertEqual(countSix, 6)
        }
    }
    
    
    // Mark: - Test Read
    func testReadAll() {
        purgeDatabase()
        _ = try? Article.importList(mockArticleListResponseJSON, idKey: "id", shouldSave: true, context: context)
        let articles = try? Article.readAll(context: context)
        XCTAssertEqual(articles?.count, 6)
    }
    
    // Mark: - Test Read
    func testReadFirst() {
        do {
            purgeDatabase()
            _ = try Article.importList(mockArticleListResponseJSON, idKey: "id", shouldSave: true, context: context)
            let randId = Int16.random(in: 1 ... 6)
            let article = try Article.readFirst(NSPredicate(format: "id == \(randId)"), context: context)
            XCTAssertEqual(article!.id, randId)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
