//
//  NSManagedObject+CoreData.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


// MARK: - Read Helpers
extension NSFetchRequestResult where Self: NSManagedObject {
    
    // MARK: - Sync Read
    static public func syncFetchRequest(_ context: NSManagedObjectContext) -> NSFetchRequest<Self> {
        let fetchRequest = NSFetchRequest<Self>()
        fetchRequest.entity = entity()
        return fetchRequest
    }
    
    // MARK: - Async Read
    static public func asyncFetchRequest(_ fetchRequest: NSFetchRequest<Self>,
                                         context: NSManagedObjectContext,
                                         completion: @escaping (EZCoreDataResult<[Self]>) -> Void) {
        let asynchronousFetchRequest = NSAsynchronousFetchRequest<Self>(fetchRequest: fetchRequest) { (asyncFetchResult) in
            if let fetchedObjects = asyncFetchResult.finalResult {
                completion(.success(result: fetchedObjects))
            }
        }
        
        do {
            let _ = try context.execute(asynchronousFetchRequest)
        } catch {
            EZCoreDataLogger.logError(error.localizedDescription)
            completion(.failure(error: error))
        }
    }
    
}
