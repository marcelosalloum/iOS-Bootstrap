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
    
//    NSPersistentContainer has two properties, more specifically, the property and method: viewContext and newBackgroundContext. The first is associated with the main queue, the second with privateQueueConcurrencyType. When we write something in newBackgroundContext, it sends a notification for viewContext object to merge content. Therefore, it appears that we no longer need to subscribe to this notification. From viewContext documentation:
    
    static let shared: CoreDataManager = CoreDataManager{}
    
    var persistentContainer: NSPersistentContainer
    
    var managedObjectContext: NSManagedObjectContext {  // mainQueueContext //    is associated with the mainQueue
        get {
            return persistentContainer.viewContext
        }
    }
    
    func newPrivateQueueContext() -> NSManagedObjectContext {  // newPrivateQueueContext    is associated with the privateQueueConcurrencyType
        return persistentContainer.newBackgroundContext()
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
