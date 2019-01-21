//
//  NSManagedObjectContext+Save.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 21/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


public extension NSManagedObjectContext {
    
    /// Saves the context ASYNCRONOUSLY. Also saves context parents recursively (parent, then parent's parent, and so on
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
    
    /// Saves the context SYNCRONOUSLY. Also saves context parents recursively (parent, then parent's parent, and so on
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
    
    /// Saves the context if there is any changes
    private func regularSaveFlow() throws {
        if !hasChanges {
            EZCoreDataLogger.log("Context has no changes to be saved")
            return
        }
        try save()
        EZCoreDataLogger.log("Context successfully saved")
    }
    
}
