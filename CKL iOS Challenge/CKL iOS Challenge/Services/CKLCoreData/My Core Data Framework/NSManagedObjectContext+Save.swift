//
//  NSManagedObjectContext+Save.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 21/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


/**
 Convenience extension to `NSManagedObjectContext` that ensures that saves to contexts of type
 `MainQueueConcurrencyType` and `PrivateQueueConcurrencyType` are dispatched on the correct GCD queue.
 */
public extension NSManagedObjectContext {
    /**
     Convenience method to asynchronously save the `NSManagedObjectContext` if changes are present.
     If any parent contexts are found, they too will be saved asynchronously.
     Method also ensures that the save is executed on the correct queue when using Main/Private queue concurrency types.
     
     - parameter completion: Completion closure with a `EZCoreDataResult` to be executed
     either upon the completion of the top most context's save operation or the first encountered save error.
     */
    public func saveContextToStore(_ completion: @escaping (EZCoreDataResult<Any>) -> Void) {
        func saveFlow() {
            do {
                try regularSaveFlow()
                if let parentContext = parent {
                    parentContext.saveContextToStore(completion)
                } else {
                    completion(.success(result: nil))
                }
            } catch let error {
                EZCoreDataLogger.logError("Unable to Save Changes of Private Managed Object Context")
                EZCoreDataLogger.logError(error.localizedDescription)
                completion(.failure(error: error))
            }
        }
        
        switch concurrencyType {
        case .confinementConcurrencyType:
            saveFlow()
        case .privateQueueConcurrencyType,
             .mainQueueConcurrencyType:
            perform(saveFlow)
        }
    }
    
    public func saveContextToStore() {
        do {
            try regularSaveFlow()
            if let parentContext = parent {
                return parentContext.saveContextToStore()
            } else {
                return
            }
        } catch let error {
            EZCoreDataLogger.logError("Unable to Save Changes of Private Managed Object Context")
            EZCoreDataLogger.logError(error.localizedDescription)
            return
        }
    }
    
    private func regularSaveFlow() throws {
        if !hasChanges {
            EZCoreDataLogger.log("Context has no changes to be saved")
            return
        }
        try save()
        EZCoreDataLogger.log("Context successfully saved")
    }
    
}
