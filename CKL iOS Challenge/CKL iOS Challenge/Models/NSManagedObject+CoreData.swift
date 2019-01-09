//
//  NSManagedObject+CoreData.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 09/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData

/**
 Extends `NSFetchRequestResult` with
 methods that make fetching, inserting, deleting, and change management easier.
 */
@available(iOS, introduced: 10.0)
@available(tvOS, introduced: 10.0)
@available(OSX, introduced: 10.12)
extension NSFetchRequestResult where Self: NSManagedObject {
    /**
     Creates a new fetch request for the `NSManagedObject` entity.
     
     - parameter context: `NSManagedObjectContext` to create the object within.
     
     - returns: `NSFetchRequest`: The new fetch request.
     */
    static public func fetchRequestForEntity(inContext context: NSManagedObjectContext) -> NSFetchRequest<Self> {
        let fetchRequest = NSFetchRequest<Self>()
        fetchRequest.entity = entity()
        return fetchRequest
    }
    
    static public func executeAsyncRequest(_ context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Self>, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        let asynchronousFetchRequest = NSAsynchronousFetchRequest<Self>(fetchRequest: fetchRequest) { (asyncFetchResult) in
            if let fetchedObjects = asyncFetchResult.finalResult {
                success(fetchedObjects)
            }
        }
        
        do {
            // Execute Asynchronous Fetch Request
            let asynchronousFetchResult = try context.execute(asynchronousFetchRequest)
            print(asynchronousFetchResult)
            
        } catch {
            print("ERROR: \(error.localizedDescription)")  // TODO: turn on/off verbose option
            failure?(error)
        }
    }
    
    /**
     Fetches the first Entity that matches the optional predicate within the specified `NSManagedObjectContext`.
     
     - parameter context: `NSManagedObjectContext` to find the entities within.
     - parameter predicate: An optional `NSPredicate` for filtering
     
     - throws: Any error produced from `executeFetchRequest`
     
     - returns: `Self?`: The first entity that matches the optional predicate or `nil`.
     */
    static public func findFirstInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil) throws -> Self? {
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 1
        return try context.fetch(fetchRequest).first
    }
    
    /**
     Fetches all Entities within the specified `NSManagedObjectContext`.
     
     - parameter context: `NSManagedObjectContext` to find the entities within.
     - parameter sortDescriptors: Optional array of `NSSortDescriptors` to apply to the fetch
     - parameter predicate: An optional `NSPredicate` for filtering
     
     - throws: Any error produced from `executeFetchRequest`
     
     - returns: `[Self]`: The array of matching entities.
     */
    
    fileprivate static func fetchRequestAllInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Self> {
        // Prepare the request
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    static public func allInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Self] {
        // Prepare the request
        let fetchRequest = fetchRequestAllInContext(context, predicate: predicate, sortDescriptors: sortDescriptors)
        return try context.fetch(fetchRequest)
    }
    
    static public func asyncAllInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Prepare the request
        let fetchRequest = fetchRequestAllInContext(context, predicate: predicate, sortDescriptors: sortDescriptors)
        executeAsyncRequest(context, fetchRequest: fetchRequest, success: success, failure: failure)
    }
    
    
    /**

     */
    
    fileprivate static func fetchRequestInContext(_ context: NSManagedObjectContext, attribute: String? = nil, value: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Self> {
        // Prepare the request
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.sortDescriptors = sortDescriptors
        if let attribute = attribute, let value = value {
            fetchRequest.predicate = NSPredicate(format: "\(attribute) == \(value)")
        }
        return fetchRequest
    }
    
    static public func fetchInContext(_ context: NSManagedObjectContext, attribute: String? = nil, value: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Self] {
        // Prepare the request
        let fetchRequest = fetchRequestInContext(context, attribute: attribute, value: value, sortDescriptors: sortDescriptors)
        return try context.fetch(fetchRequest)
    }
    
    static public func asyncFetch(_ context: NSManagedObjectContext, attribute: String? = nil, value: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Prepare the request
        let fetchRequest = fetchRequestInContext(context, attribute: attribute, value: value, sortDescriptors: sortDescriptors)
        executeAsyncRequest(context, fetchRequest: fetchRequest, success: success, failure: failure)
    }
    
    
    // MARK: - Counting Objects
    
    /**
     Returns count of Entities that matches the optional predicate within the specified `NSManagedObjectContext`.
     
     - parameter context: `NSManagedObjectContext` to count the entities within.
     - parameter predicate: An optional `NSPredicate` for filtering
     
     - throws: Any error produced from `countForFetchRequest`
     
     - returns: `Int`: Count of entities that matches the optional predicate.
     */
    
    fileprivate static func fetchRequestCountInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> NSFetchRequest<Self> {
        // Prepare the request
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    static public func countInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil) throws -> Int {
        // Prepare the request
        let fetchRequest = fetchRequestCountInContext(context, predicate: predicate)
        return try context.count(for: fetchRequest)
    }
    
    static public func asyncCountInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Prepare the request
        let fetchRequest = fetchRequestCountInContext(context, predicate: predicate)
        executeAsyncRequest(context, fetchRequest: fetchRequest, success: success, failure: failure)
    }
    
    // MARK: - Removing Objects
    
    /**
     Removes all entities from within the specified `NSManagedObjectContext`.
     
     - parameter context: `NSManagedObjectContext` to remove the entities from.
     
     - throws: Any error produced from `executeFetchRequest`
     */
    static public func removeAllInContext(_ context: NSManagedObjectContext) throws {
        let fetchRequest = fetchRequestForEntity(inContext: context)
        try removeAllObjectsReturnedByRequest(fetchRequest, inContext: context)
    }
    
    /**
     Removes all entities from within the specified `NSManagedObjectContext` excluding a supplied array of entities.
     
     - parameter context: The `NSManagedObjectContext` to remove the Entities from.
     - parameter except: An Array of `NSManagedObjects` belonging to the `NSManagedObjectContext` to exclude from deletion.
     
     - throws: Any error produced from `executeFetchRequest`
     */
    static public func removeAllInContext(_ context: NSManagedObjectContext, except toKeep: [Self]) throws {
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.predicate = NSPredicate(format: "NOT (self IN %@)", toKeep)
        try removeAllObjectsReturnedByRequest(fetchRequest, inContext: context)
    }
    
    // MARK: Private Funcs
    
    static private func removeAllObjectsReturnedByRequest(_ fetchRequest: NSFetchRequest<Self>, inContext context: NSManagedObjectContext) throws {
        // A batch delete would be more efficient here on iOS 9 and up
        //  however it complicates things since the request requires a context with
        //  an NSPersistentStoreCoordinator directly connected. (MOC cannot be a child of another MOC)
        fetchRequest.includesPropertyValues = false
        fetchRequest.includesSubentities = false
        try context.fetch(fetchRequest).lazy.forEach(context.delete(_:))
    }
}
