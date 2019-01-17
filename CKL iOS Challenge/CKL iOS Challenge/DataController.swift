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


class DataController: NSObject {
    var persistentContainer: NSPersistentContainer
    var managedObjectContext: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
    init(_ completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: Constants.databaseName)
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
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
