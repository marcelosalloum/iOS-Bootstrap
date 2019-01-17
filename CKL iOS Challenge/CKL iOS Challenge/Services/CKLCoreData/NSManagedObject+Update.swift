//
//  NSManagedObject+Update.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


extension NSFetchRequestResult where Self: NSManagedObject {
    
    // MARK: - Get or Create
    static func getOrCreateResult(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Self>, attribute: String?, value: String?) -> AwesomeDataResult<Self> {
        // Initializing return variables
        var object: Self!
        var fetchedObjects: [Self] = []
        
        // GET, if idKey exists
        do {
            fetchedObjects = try readAwesome(inContext: context, attribute: attribute, value: value, sortDescriptors: nil)
        } catch let error as NSError {
            CKLCoreData.log("ERROR: \(error.localizedDescription)")
            return AwesomeDataResult<Self>.failure(error: error)
        }
        
        // CREATE if idKey doesn't exist
        if (fetchedObjects.count > 0) {
            object = fetchedObjects[0]
        } else {
            object = Self.init(entity: self.entity(), insertInto: context)
        }
        
        return AwesomeDataResult<Self>.success(objectList: object)
    }
    
    static func getOrCreate(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Self>, attribute: String?, value: String?) -> Self? {
        switch self.getOrCreateResult(context: context, fetchRequest: fetchRequest, attribute: attribute, value: value) {
        case .success(objectList: let object):
            guard let object = object else { return nil }
            return object
        case .failure(error: _):
            return nil
        }
    }
    
    // MARK: - Import from JSON
    static func importObjects(_ jsonArray: [JSON]?, context: NSManagedObjectContext, idKey: String = "id", shouldSave: Bool) throws -> [Self]? {
        // Input validations
        guard let jsonArray = jsonArray else { throw CKLCoreDataError.contextIsEmpty }
        if jsonArray.isEmpty { throw CKLCoreDataError.jsonIsEmpty }
        var objectsArray: [Self] = []
        
        // Basic CoreData Setup
        let fetchRequest = syncFetchRequest(inContext: context)
        
        // Looping over the articles
        for objectJSON in jsonArray {
            // GET or CREATE
            let objectId = String(objectJSON["\(idKey)"].intValue)
            guard let object = self.getOrCreate(context: context, fetchRequest: fetchRequest, attribute: idKey, value: objectId) else { throw CKLCoreDataError.getOrCreateObjIsEmpty }
            objectsArray.append(object)
        }
        
        // Context Save
        if (shouldSave) {
            try save(context)
        }
        return objectsArray
    }
    
    static func asyncImportObjects(_ jsonArray: [JSON]?, context: NSManagedObjectContext, completion: @escaping (AwesomeDataResult<[Self]>) -> (), idKey: String = "id") {
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = context
        
        privateContext.perform {
            // Input validations
            guard let jsonArray = jsonArray else { return }
            if jsonArray.isEmpty { return }
            var objectsArray: [Self] = []
            
            // Basic CoreData Setup
            let fetchRequest = syncFetchRequest(inContext: context)
            
            // Looping over the articles
            for objectJSON in jsonArray {
                
                // GET or CREATE
                let objectId = String(objectJSON["\(idKey)"].intValue)
                guard let object = self.getOrCreate(context: context, fetchRequest: fetchRequest, attribute: idKey, value: objectId) else {
                    completion(AwesomeDataResult<[Self]>.failure(error: CKLCoreDataError.getOrCreateObjIsEmpty))
                    return
                }
                objectsArray.append(object)
            }
            
            // Context Save
            do {
                try save(context)
                completion(AwesomeDataResult<[Self]>.success(objectList: objectsArray))
            } catch let error {
                CKLCoreData.log("ERROR: \(error.localizedDescription)")
                completion(AwesomeDataResult<[Self]>.failure(error: error))
            }
        }
    }
}
