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
            fetchedObjects = try readAwesome(inContext: context, attribute: attribute, value: value, sortDescriptors: nil)
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
    static func readFirstFetchRequest(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> NSFetchRequest<Self> {
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 1
        return fetchRequest
    }
    
    static public func readFirst(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil) throws -> Self? {
        let fetchRequest = readFirstFetchRequest(inContext: context, predicate: predicate)
        return try context.fetch(fetchRequest).first
    }
    
    static public func asyncReadFirst(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        let fetchRequest = readFirstFetchRequest(inContext: context, predicate: predicate)
        asyncFetchRequest(inContext: context, fetchRequest: fetchRequest, completion: { dataResult in
            switch dataResult {
            case .success(objectList: let objectList):
                if let objectList = objectList { success(objectList) }
            case .failure(error: let error):
                failure?(error)
            }
        })
    }
    
    // Read From Predicate
    fileprivate static func readAllFetchRequest(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Self> {
        // Prepare the request
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    static public func readAll(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Self] {
        // Prepare the request
        let fetchRequest = readAllFetchRequest(inContext: context, predicate: predicate, sortDescriptors: sortDescriptors)
        return try context.fetch(fetchRequest)
    }
    
    static public func asyncReadAll(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Prepare the request
        let fetchRequest = readAllFetchRequest(inContext: context, predicate: predicate, sortDescriptors: sortDescriptors)
        asyncFetchRequest(inContext: context, fetchRequest: fetchRequest, completion: { dataResult in
            switch dataResult {
            case .success(objectList: let objectList):
                if let objectList = objectList { success(objectList) }
            case .failure(error: let error):
                failure?(error)
            }
        })
    }
    
    /**
     Read objects with attribute
     SELECT (*) from Article WHERE "attribute" equals "value"
     */
    fileprivate static func readAwesomeFetchRequest(inContext context: NSManagedObjectContext, attribute: String? = nil, value: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Self> {
        // Prepare the request
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.sortDescriptors = sortDescriptors
        if let attribute = attribute, let value = value {
            fetchRequest.predicate = NSPredicate(format: "\(attribute) == \(value)")
        }
        return fetchRequest
    }
    
    static public func readAwesome(inContext context: NSManagedObjectContext, attribute: String? = nil, value: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Self] {
        // Prepare the request
        let fetchRequest = readAwesomeFetchRequest(inContext: context, attribute: attribute, value: value, sortDescriptors: sortDescriptors)
        return try context.fetch(fetchRequest)
    }
    
    static public func asyncReadAwesome(inContext context: NSManagedObjectContext, attribute: String? = nil, value: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Prepare the request
        let fetchRequest = readAwesomeFetchRequest(inContext: context, attribute: attribute, value: value, sortDescriptors: sortDescriptors)
        asyncFetchRequest(inContext: context, fetchRequest: fetchRequest, completion: { dataResult in
            switch dataResult {
            case .success(objectList: let objectList):
                if let objectList = objectList { success(objectList) }
            case .failure(error: let error):
                failure?(error)
            }
        })
    }
    
    // Count
    fileprivate static func countFetchRequest(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> NSFetchRequest<Self> {
        // Prepare the request
        let fetchRequest = fetchRequestForEntity(inContext: context)
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    static public func count(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil) throws -> Int {
        // Prepare the request
        let fetchRequest = countFetchRequest(inContext: context, predicate: predicate)
        return try context.count(for: fetchRequest)
    }
    
    static public func asycCount(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Prepare the request
        let fetchRequest = countFetchRequest(inContext: context, predicate: predicate)
        asyncFetchRequest(inContext: context, fetchRequest: fetchRequest, completion: { dataResult in
            switch dataResult {
            case .success(objectList: let objectList):
                if let objectList = objectList { success(objectList) }
            case .failure(error: let error):
                failure?(error)
            }
        })
    }
}

