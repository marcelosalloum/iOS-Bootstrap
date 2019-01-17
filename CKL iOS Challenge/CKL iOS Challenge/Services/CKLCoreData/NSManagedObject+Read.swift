//
//  NSManagedObject+Read.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


extension NSFetchRequestResult where Self: NSManagedObject {
    
    
    // MARK: - Read First
    static func readFirstFetchRequest(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> NSFetchRequest<Self> {
        let fetchRequest = syncFetchRequest(inContext: context)
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
    
    static public func asyncReadFirst(inContext context: NSManagedObjectContext,
                                      predicate: NSPredicate? = nil,
                                      completion: @escaping (AwesomeDataResult<Self>) -> Void) {
        let fetchRequest = readFirstFetchRequest(inContext: context, predicate: predicate)
        asyncFetchRequest(inContext: context, fetchRequest: fetchRequest, completion: {awesomeResult in
            switch awesomeResult {
            case AwesomeDataResult<[Self]>.success(objectList: let objectList):
                let firstObject: Self? = objectList?.first
                completion(AwesomeDataResult<Self>.success(objectList: firstObject))
            case AwesomeDataResult<[Self]>.failure(error: let error):
                completion(AwesomeDataResult<Self>.failure(error: error))
            }
        })
    }
    
    
    // MARK: - Read All
    fileprivate static func readAllFetchRequest(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Self> {
        // Prepare the request
        let fetchRequest = syncFetchRequest(inContext: context)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    static public func readAll(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Self] {
        // Prepare the request
        let fetchRequest = readAllFetchRequest(inContext: context, predicate: predicate, sortDescriptors: sortDescriptors)
        return try context.fetch(fetchRequest)
    }
    
    static public func asyncReadAll(_ context: NSManagedObjectContext,
                                    predicate: NSPredicate? = nil,
                                    sortDescriptors: [NSSortDescriptor]? = nil,
                                    completion: @escaping (AwesomeDataResult<[Self]>) -> Void) {
        // Prepare the request
        let fetchRequest = readAllFetchRequest(inContext: context, predicate: predicate, sortDescriptors: sortDescriptors)
        asyncFetchRequest(inContext: context, fetchRequest: fetchRequest, completion: completion)
    }
    
    
    // MARK: - Read With Attributes
    fileprivate static func readAwesomeFetchRequest(inContext context: NSManagedObjectContext, attribute: String? = nil, value: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Self> {
        // Prepare the request
        let fetchRequest = syncFetchRequest(inContext: context)
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
    
    static public func asyncReadAwesome(inContext context: NSManagedObjectContext,
                                        attribute: String? = nil,
                                        value: String? = nil,
                                        sortDescriptors: [NSSortDescriptor]? = nil,
                                        completion: @escaping (AwesomeDataResult<[Self]>) -> Void) {
        // Prepare the request
        let fetchRequest = readAwesomeFetchRequest(inContext: context, attribute: attribute, value: value, sortDescriptors: sortDescriptors)
        asyncFetchRequest(inContext: context, fetchRequest: fetchRequest, completion: completion)
    }
    

    // MARK: - Count
    static public func count(inContext context: NSManagedObjectContext, predicate: NSPredicate? = nil) throws -> Int {
        // Prepare the request
        let fetchRequest = syncFetchRequest(inContext: context)
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate
        return try context.count(for: fetchRequest)
    }
}

