//
//  NSManagedObject+Read.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


public enum GetOrCreate: String {
    case error
    case get
    case create
}


extension CKLCoreDataProtocol where Self: NSManagedObject {
    /*
     GET or CREATE
     */
    
    static func getOrCreate(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Self>, attribute: String?, value: String?) -> (Self?, GetOrCreate?, Error?) {
        // Initializing return variables
        var object: Self?
        var getOrCreate: GetOrCreate = .error
        var fetchedObjects: [Self] = []
        
        // GET
        do {
            fetchedObjects = try fetchInContext(context, attribute: attribute, value: value, sortDescriptors: nil)
        } catch let error as NSError {
            CKLCoreData.log("ERROR: \(error.localizedDescription)")
            return (object, getOrCreate, error)
        }
        
        // If GET is empty, then CREATE
        if (fetchedObjects.count > 0) {
            object = fetchedObjects[0]
            getOrCreate = .get
        } else {
            object = Self.init(entity: self.entity(), insertInto: context)
            getOrCreate = .create
        }
        
        return (object, getOrCreate, nil)
    }
    
    // Read First
    static func findFirstFetchRequest(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> NSFetchRequest<Self> {
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 1
        return fetchRequest
    }
    
    static public func findFirst(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil) throws -> Self? {
        let fetchRequest = findFirstFetchRequest(inContext: context, predicate: predicate)
        return try context.fetch(fetchRequest).first
    }
    
    static public func findFirstAsync(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        let fetchRequest = findFirstFetchRequest(inContext: context, predicate: predicate)
        executeAsyncFetchRequest(inContext: context, fetchRequest: fetchRequest, success: success, failure: failure)
    }
    
    // Read From Predicate
    fileprivate static func readObjects(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Self> {
        // Prepare the request
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    static public func readObjects(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Self] {
        // Prepare the request
        let fetchRequest = readObjects(inContext: context, predicate: predicate, sortDescriptors: sortDescriptors)
        return try context.fetch(fetchRequest)
    }
    
    static public func asyncReadObjects(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Prepare the request
        let fetchRequest = readObjects(inContext: context, predicate: predicate, sortDescriptors: sortDescriptors)
        executeAsyncFetchRequest(inContext: context, fetchRequest: fetchRequest, success: success, failure: failure)
    }
    
    /**
     Read objects with attribute
     SELECT (*) from Article WHERE "attribute" equals "value"
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
    
    static public func asyncFetchInContext(_ context: NSManagedObjectContext, attribute: String? = nil, value: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Prepare the request
        let fetchRequest = fetchRequestInContext(context, attribute: attribute, value: value, sortDescriptors: sortDescriptors)
        executeAsyncFetchRequest(inContext: context, fetchRequest: fetchRequest, success: success, failure: failure)
    }
    
    // Count
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
        executeAsyncFetchRequest(inContext: context, fetchRequest: fetchRequest, success: success, failure: failure)
    }
}

