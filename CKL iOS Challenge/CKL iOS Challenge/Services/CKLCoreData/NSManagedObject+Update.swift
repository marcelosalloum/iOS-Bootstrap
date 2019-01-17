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
    
    /*
     Import from JSON
     */
    static func asyncImportObjects(_ jsonArray: [JSON]?, context: NSManagedObjectContext, completion: (AwesomeDataResult<[Self]>) -> (), idKey: String = "id", save: Bool = true) {
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
            let (getOrCreateObj, _, error) = Self.getOrCreate(context: context, fetchRequest: fetchRequest, attribute: "id", value: objectId)
            
            // Error handling [GET or CREATE]
            if let error = error {
                completion(.failure(error: error))
                return
            }
            guard let object = getOrCreateObj else { return }
            CKLCoreData.shared.importJSON(from: objectJSON, toObject: object)
            objectsArray.append(object)
        }
        
        // Context Save
        if (save) {
            asyncSave(context) { (inwardCompletion) in
                switch inwardCompletion {
                case .success(objectList: _):
                    completion(AwesomeDataResult<[Self]>.success(objectList: objectsArray))
                case .failure(error: let error):
                    completion(AwesomeDataResult<[Self]>.failure(error: error))
                }
            }
        } else {
            completion(AwesomeDataResult<[Self]>.success(objectList: objectsArray))
        }
    }
    
    static func asyncSave(_ context: NSManagedObjectContext, completion: (AwesomeDataResult<[Self]>) -> ()) {
        do {
            if context.hasChanges {
                try context.save()
            } else {
                CKLCoreData.log("WARNING, there is no new data to save in the Core Data")
            }
            completion(.success(objectList: nil))
        } catch let error as NSError {
            CKLCoreData.log("ERROR: \(error.localizedDescription)")
            completion(.failure(error: error))
        }
    }
    
    static func importObjects(_ jsonArray: [JSON]?, context: NSManagedObjectContext, idKey: String = "id", save: Bool = true) throws -> [Self]? {
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
            let (getOrCreateObj, _, error) = Self.getOrCreate(context: context, fetchRequest: fetchRequest, attribute: "id", value: objectId)
            
            // Error handling [GET or CREATE]
            if let err = error {
                throw err
            }
            guard let object = getOrCreateObj else { throw CKLCoreDataError.getOrCreateObjIsEmpty }
            CKLCoreData.shared.importJSON(from: objectJSON, toObject: object)
            objectsArray.append(object)
        }
        
        // Context Save
        if (save) {
            try context.save()
        }
        return objectsArray
    }
}
