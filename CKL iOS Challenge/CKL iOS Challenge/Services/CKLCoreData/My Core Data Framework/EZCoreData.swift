//
//  DataController.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 17/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import CoreData


// MARK: - Basic Setup
public class EZCoreData: NSObject {
    
    /// Daatabase Name. Default value is `EZCoreData_DBName`
    static var databaseName: String = "EZCoreData_DBName"

    /// Shared instance of `EZCoreData`. If the shared version is not enough for your case, you're encoouraged to create an intance of your own
    static let shared: EZCoreData = EZCoreData {}
    
    var persistentContainer: NSPersistentContainer
    
    /// NSManagedObjectContext that executes in Main Thread
    lazy var mainThredContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    /// static NSManagedObjectContext that executes in Main Thread
    public static var mainThredContext: NSManagedObjectContext {
        return shared.mainThredContext
    }
    
    /// NSManagedObjectContext that executes in a Private Thread
    lazy var privateThreadContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        managedObjectContext.parent = self.mainThredContext
        
        return managedObjectContext
    }()
    
    /// static NSManagedObjectContext that executes in a Private Thread
    public static var privateThreadContext: NSManagedObjectContext {
        return shared.privateThreadContext
    }
    
    // MARK: - Init
    /// Async initialization of the NSPersistentContainer
    init(_ completion: @escaping () -> Void) {
        persistentContainer = NSPersistentContainer(name: EZCoreData.databaseName)
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completion()
        }
    }
}
