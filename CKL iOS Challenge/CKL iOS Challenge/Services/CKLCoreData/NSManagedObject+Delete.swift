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
    static public func deleteAll(inContext context: NSManagedObjectContext, except toKeep: [Self]? = nil) throws {
        let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        deleteFetchRequest.entity = entity()
        if let toKeep = toKeep, toKeep.count > 0 {
            deleteFetchRequest.predicate = NSPredicate(format: "NOT (self IN %@)", toKeep)
        }
        try deleteAllFromFetchRequest(deleteFetchRequest, inContext: context)
    }
    
    // MARK: - Remove All that match attribute
    static public func deleteAll(inContext context: NSManagedObjectContext, except attributeName: String, toKeep: [String]) throws {
        let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        deleteFetchRequest.entity = entity()
        deleteFetchRequest.predicate = NSPredicate(format: "NOT (\(attributeName) IN %@)", toKeep)
        try deleteAllFromFetchRequest(deleteFetchRequest, inContext: context)
    }
    
    // MARK: - Private Funcs
    fileprivate static func deleteAllFromFetchRequest(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>, inContext context: NSManagedObjectContext) throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }
}
