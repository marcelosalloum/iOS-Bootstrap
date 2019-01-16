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


extension CKLCoreDataProtocol where Self: NSManagedObject {
    /*
     Import from JSON
     */
    static func asyncImportObjects(_ jsonArray: [JSON]?, context: NSManagedObjectContext, completion: (Completion<Self>) -> (), idKey: String = "id", save: Bool = true) {
        // Input validations
        guard let jsonArray = jsonArray else { return }
        if jsonArray.isEmpty { return }
        var objectsArray: [Self] = []
        
        // Basic CoreData Setup
        let fetchRequest = fetchRequestForEntity(inContext: context)
        
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
                case .success(objects: _):
                    completion(Completion<Self>.success(objects: objectsArray))
                case .failure(error: let error):
                    completion(Completion<Self>.failure(error: error))
                }
            }
        } else {
            completion(Completion<Self>.success(objects: objectsArray))
        }
    }
    
    static func asyncSave(_ context: NSManagedObjectContext, completion: (Completion<Self>) -> ()) {
        do {
            if context.hasChanges {
                try context.save()
                CKLCoreData.log("WARNING, variable \"CONTEXT\" is empty")
            }
            completion(.success(objects: nil))
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
        let fetchRequest = fetchRequestForEntity(inContext: context)
        
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
