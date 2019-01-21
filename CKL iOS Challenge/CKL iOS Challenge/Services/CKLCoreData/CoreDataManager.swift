//
//  DataController.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 17/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics


class CoreDataManager: NSObject {
    
    static let shared: CoreDataManager = CoreDataManager{}
    
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
    
    init(_ completion: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: Constants.databaseName)
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completion()
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("ERROR: \(error.localizedDescription)")
                Answers.logCustomEvent(withName: "Crash on method DataController.saveContext()", customAttributes: ["DataController.saveContext()": error.localizedDescription])
                }
        }
    }
}
