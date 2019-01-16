//
//  NSManagedObject+CoreData.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


public enum AwesomeDataResult<Object> {
    case success(objectList: [Object]?)
    case failure(error: Error)
}


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
    
    // MARK: - READ ASYNC
    static public func asyncFetchRequest(inContext context: NSManagedObjectContext,
                                                fetchRequest: NSFetchRequest<Self>,
                                                completion: @escaping (AwesomeDataResult<Self>) -> Void) {
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
    
}
