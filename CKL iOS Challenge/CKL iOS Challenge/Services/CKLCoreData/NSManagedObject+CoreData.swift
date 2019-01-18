//
//  NSManagedObject+CoreData.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


// MARK: - Error Handling
public enum AwesomeDataResult<Object> {
    case success(objectList: Object?)
    case failure(error: Error)
}


// MARK: - Used for importing a JSON into an NSManagedObjectContext
extension NSManagedObject {
    @objc func populateFromJSON(_ json: [String: Any]) {
        print("NSManagedObject")
    }
}


// MARK: - Read Helpers
extension NSFetchRequestResult where Self: NSManagedObject {
    
    // MARK: - Sync Read
    static public func syncFetchRequest(inContext context: NSManagedObjectContext) -> NSFetchRequest<Self> {
        let fetchRequest = NSFetchRequest<Self>()
        fetchRequest.entity = entity()
        return fetchRequest
    }
    
    // MARK: - Async Read
    static public func asyncFetchRequest(inContext context: NSManagedObjectContext,
                                         fetchRequest: NSFetchRequest<Self>,
                                         completion: @escaping (AwesomeDataResult<[Self]>) -> Void) {
        let asynchronousFetchRequest = NSAsynchronousFetchRequest<Self>(fetchRequest: fetchRequest) { (asyncFetchResult) in
            if let fetchedObjects = asyncFetchResult.finalResult {
                completion(.success(objectList: fetchedObjects))
            }
        }
        
        do {
            let _ = try context.execute(asynchronousFetchRequest)
        } catch {
            CKLCoreData.log("ERROR: \(error.localizedDescription)")
            completion(.failure(error: error))
        }
    }
    
    // MARK: - Async Save
    static func asyncSave(_ context: NSManagedObjectContext, completion: (AwesomeDataResult<[Self]>) -> ()) {
        do {
            try save(context)
            completion(.success(objectList: nil))
        } catch let error as NSError {
            CKLCoreData.log("ERROR: \(error.localizedDescription)")
            completion(.failure(error: error))
        }
    }
    
    
    static func save(_ context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        } else {
            CKLCoreData.log("WARNING, there is no new data to save in the Core Data")
        }
    }
}
