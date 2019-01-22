//
//  NSManagedObject+Delete.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


// MARK: - Delete One
extension NSFetchRequestResult where Self: NSManagedObject {
    /// Delete given object within the given context
    static public func delete(_ object: Self, shouldSave: Bool = true, context: NSManagedObjectContext = EZCoreData.mainThredContext) throws {
        context.delete(object)
        if (shouldSave) {
            try context.save()
        }
    }
    
    /// Delete the object within the given context
    public func delete(shouldSave: Bool = true, context: NSManagedObjectContext = EZCoreData.mainThredContext) throws {
        try Self.delete(self, shouldSave: shouldSave, context: context)
    }
}


// MARK: - Delete All
extension NSFetchRequestResult where Self: NSManagedObject {
    
    /// SYNC Delete all objects of this kind except the given list
    static public func deleteAll(except toKeep: [Self]? = nil,
                                 context: NSManagedObjectContext = EZCoreData.mainThredContext) throws {
        // Fech Reqest
        let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        deleteFetchRequest.entity = entity()
        // Predicate
        if let toKeep = toKeep, toKeep.count > 0 {
            deleteFetchRequest.predicate = NSPredicate(format: "NOT (self IN %@)", toKeep)
        }
        // Delete Request
        try deleteAllFromFetchRequest(deleteFetchRequest, context: context)
    }
    
    /// ASYNC Delete all objects of this kind except the given list
    static public func deleteAll(except toKeep: [Self]? = nil,
                                 backgroundContext: NSManagedObjectContext = EZCoreData.privateThreadContext,
                                 completion: @escaping (EZCoreDataResult<[Self]>) -> Void) {
        backgroundContext.perform {
            let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
            deleteFetchRequest.entity = entity()
            if let toKeep = toKeep, toKeep.count > 0 {
                deleteFetchRequest.predicate = NSPredicate(format: "NOT (self IN %@)", toKeep)
            }
            // Delete Request
            do {
                try deleteAllFromFetchRequest(deleteFetchRequest, context: backgroundContext)
//                try print(Article.count(context: backgroundContext))
//                try print(Article.count(context: context))
                completion(.success(result: nil))
                EZCoreDataLogger.log("Deleted list of objects")
            } catch let error {
                EZCoreDataLogger.logError(error.localizedDescription)
                completion(.failure(error: error))
            }
        }
    }
}


// MARK: - Delete All By Attribute
extension NSFetchRequestResult where Self: NSManagedObject {
    
    /// SYNC Delete all objects of this kind except those with the given attribute
    static public func deleteAllByAttribute(except attributeName: String,
                                            toKeep: [String],
                                            context: NSManagedObjectContext = EZCoreData.mainThredContext) throws {
        let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        deleteFetchRequest.entity = entity()
        deleteFetchRequest.predicate = NSPredicate(format: "NOT (\(attributeName) IN %@)", toKeep)
        try deleteAllFromFetchRequest(deleteFetchRequest, context: context)
    }
    
    /// ASYNC Delete all objects of this kind except those with the given attribute
    static public func deleteAllByAttribute(except attributeName: String,
                                            toKeep: [String],
                                            backgroundContext: NSManagedObjectContext = EZCoreData.privateThreadContext,
                                            completion: @escaping (EZCoreDataResult<[Self]>) -> Void) {
        backgroundContext.perform {
            let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>()
            deleteFetchRequest.entity = entity()
            deleteFetchRequest.predicate = NSPredicate(format: "NOT (\(attributeName) IN %@)", toKeep)
            // Delete Request
            do {
                try deleteAllFromFetchRequest(deleteFetchRequest, context: backgroundContext)
                completion(.success(result: nil))
            } catch let error {
                EZCoreDataLogger.logError(error.localizedDescription)
                completion(.failure(error: error))
            }
        }
    }
    
    // MARK: - Private Funcs
    /// Delete all objects returned in the given NSFetchRequest
    fileprivate static func deleteAllFromFetchRequest(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>,
                                                      context: NSManagedObjectContext) throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }
}
