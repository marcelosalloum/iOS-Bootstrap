//
//  DataController.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 17/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import CoreData


class EZCoreData: NSObject {
    
    
    // MARK: - Basic Setup
    static var databaseName: String = "EZCoreData_DBName"

    // If the shared version is not enough for your case, you're encoouraged to create an intance of your own
    static let shared: EZCoreData = EZCoreData {}
    
    var persistentContainer: NSPersistentContainer
    
    // Executes in Main Thread:
    lazy var mainThredContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    // Executes in Private Thread:
    lazy var privateThreadContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        managedObjectContext.parent = self.mainThredContext
        
        return managedObjectContext
    }()
    
    
    // MARK: - Init
    init(_ completion: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: EZCoreData.databaseName)
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completion()
        }
    }
    
    // MARK: - Save
    // TODO: make a sync and n async saveChanges
    func saveChanges() {
        privateThreadContext.perform {
            do {
                if self.privateThreadContext.hasChanges {
                    try self.privateThreadContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Managed Object Context")
                print("\(saveError), \(saveError.localizedDescription)")
            }
            
            self.mainThredContext.perform {
                do {
                    if self.mainThredContext.hasChanges {
                        try self.mainThredContext.save()
                    }
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Changes of Private Managed Object Context")
                    print("\(saveError), \(saveError.localizedDescription)")
                }
            }
        }
    }
    
}
