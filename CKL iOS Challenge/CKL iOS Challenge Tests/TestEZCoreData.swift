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

//var dataManager: MockEZCoreData!

class TestEZCoreData: XCTestCase {
    
    var storeCoordinator: NSPersistentStoreCoordinator!
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: NSManagedObjectModel!
    var store: NSPersistentStore!
    let myID = "123456789"
    
    override func setUp() {
//        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
//        NSPersistentStoreCoordinator.init(managedObjectModel: <#T##NSManagedObjectModel#>)
        storeCoordinator = EZCoreData.shared.persistentContainer.persistentStoreCoordinator
        do {
            store = try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil)
        } catch let error {
            print(error.localizedDescription)
        }
        
        managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testTest() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertAndDelete() {
        do {
            // Test Count and Save methods
            let initialCount = try Article.count(context: managedObjectContext)
            print(initialCount)
            let article = Article.getOrCreate(attribute: "id", value: myID, context: managedObjectContext)
            try managedObjectContext.save()
            let countPP = try Article.count(context: managedObjectContext)
            print(countPP)
            XCTAssertEqual(initialCount + 1, countPP)

            // Test Delete and Count Methods
            try article?.delete(context: managedObjectContext)
            let finalCount = try Article.count(context: managedObjectContext)
            print(finalCount)
            XCTAssertEqual(countPP - 1, finalCount)
            XCTAssertEqual(initialCount, finalCount)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
