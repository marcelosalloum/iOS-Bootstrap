//
//  NSManagedObject+CoreData.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


public protocol CKLCoreDataProtocol {
}


extension NSManagedObject: CKLCoreDataProtocol {
}


extension CKLCoreDataProtocol where Self: NSManagedObject {
    
    // MARK: - READ SYNC
    static public func fetchRequestForEntity(inContext context: NSManagedObjectContext) -> NSFetchRequest<Self> {
        let fetchRequest = NSFetchRequest<Self>()
        fetchRequest.entity = entity()
        return fetchRequest
    }
    
    static public func executeAsyncFetchRequest(inContext context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Self>, success: @escaping (([Self]) -> Void), failure: ((Error) -> Void)? = nil) {
        let asynchronousFetchRequest = NSAsynchronousFetchRequest<Self>(fetchRequest: fetchRequest) { (asyncFetchResult) in
            if let fetchedObjects = asyncFetchResult.finalResult {
                success(fetchedObjects)
            }
        }
        
        // Execute Asynchronous Fetch Request
        do {
            let _ = try context.execute(asynchronousFetchRequest)
        } catch {
            print("ERROR: \(error.localizedDescription)")  // TODO: turn on/off verbose option
            failure?(error)
        }
    }
    
}
