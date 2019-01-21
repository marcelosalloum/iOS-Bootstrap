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
    // MARK: - Delete One
    static public func delete(inContext context: NSManagedObjectContext, object: Self) {
        context.delete(object)
    }
    
    // MARK: - Delete All
    static public func deleteAll(inContext context: NSManagedObjectContext, except toKeep: [Self]? = nil) throws {
        // Fech Reqest
        let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        deleteFetchRequest.entity = entity()
        // Predicate
        if let toKeep = toKeep, toKeep.count > 0 {
            deleteFetchRequest.predicate = NSPredicate(format: "NOT (self IN %@)", toKeep)
        }
        // Delete Request
        try deleteAllFromFetchRequest(deleteFetchRequest, inContext: context)
    }
    
    static public func asyncDeleteAll(backgroundContext: NSManagedObjectContext,
                                      except toKeep: [Self]? = nil,
                                      completion: @escaping (EZCoreDataResult<[Self]>) -> Void) {
        backgroundContext.perform {
            let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
            deleteFetchRequest.entity = entity()
            if let toKeep = toKeep, toKeep.count > 0 {
                deleteFetchRequest.predicate = NSPredicate(format: "NOT (self IN %@)", toKeep)
            }
            // Delete Request
            do {
                try deleteAllFromFetchRequest(deleteFetchRequest, inContext: backgroundContext)
//                try print(Article.count(inContext: backgroundContext))
//                try print(Article.count(inContext: context))
                completion(.success(objectList: nil))
                EZCoreDataLogger.log("Deleted list of objects")
            } catch let error {
                EZCoreDataLogger.logError(error.localizedDescription)
                completion(.failure(error: error))
            }
        }
    }
    
    // MARK: - Remove All that match attribute
    static public func deleteAll(inContext context: NSManagedObjectContext, except attributeName: String, toKeep: [String]) throws {
        let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        deleteFetchRequest.entity = entity()
        deleteFetchRequest.predicate = NSPredicate(format: "NOT (\(attributeName) IN %@)", toKeep)
        try deleteAllFromFetchRequest(deleteFetchRequest, inContext: context)
    }
    
    static public func asyncDeleteAll(backgroundContext: NSManagedObjectContext,
                                      except attributeName: String,
                                      toKeep: [String],
                                      completion: @escaping (EZCoreDataResult<[Self]>) -> Void) {
        backgroundContext.perform {
            let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
            deleteFetchRequest.entity = entity()
            deleteFetchRequest.predicate = NSPredicate(format: "NOT (\(attributeName) IN %@)", toKeep)
            // Delete Request
            do {
                try deleteAllFromFetchRequest(deleteFetchRequest, inContext: backgroundContext)
                completion(.success(objectList: nil))
            } catch let error {
                EZCoreDataLogger.logError(error.localizedDescription)
                completion(.failure(error: error))
            }
        }
    }
    
    // MARK: - Private Funcs
    fileprivate static func deleteAllFromFetchRequest(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>, inContext context: NSManagedObjectContext) throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }
}
