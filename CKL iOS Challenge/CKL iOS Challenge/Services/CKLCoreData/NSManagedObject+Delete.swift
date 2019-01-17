//
//  NSManagedObject+Delete.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


extension NSFetchRequestResult where Self: NSManagedObject {
    // MARK: - Remove All
    static public func removeAll(inContext context: NSManagedObjectContext, except toKeep: [Self]?) throws {
        let fetchRequest = syncFetchRequest(inContext: context)
        if let toKeep = toKeep, toKeep.count > 0 {
            fetchRequest.predicate = NSPredicate(format: "NOT (self IN %@)", toKeep)
        }
        try removeAllObjectsReturnedByRequest(fetchRequest, inContext: context)
    }
    
    // MARK: - Remove All that match attribute
    static public func removeAll(inContext context: NSManagedObjectContext, except attributeName: String, toKeep: [String]) throws {
        let fetchRequest = syncFetchRequest(inContext: context)
        fetchRequest.predicate = NSPredicate(format: "NOT (\(attributeName) IN %@)", toKeep)
        try removeAllObjectsReturnedByRequest(fetchRequest, inContext: context)
    }
    
    // MARK: - Private Funcs
    static private func removeAllObjectsReturnedByRequest(_ fetchRequest: NSFetchRequest<Self>, inContext context: NSManagedObjectContext) throws {
        //  A batch delete would be more efficient here on iOS 9 and up
        //  however it complicates things since the request requires a context with
        //  an NSPersistentStoreCoordinator directly connected. (MOC cannot be a child of another MOC)
        fetchRequest.includesPropertyValues = false
        fetchRequest.includesSubentities = false
        try context.fetch(fetchRequest).lazy.forEach(context.delete(_:))
    }
}
