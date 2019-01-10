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
    static func asyncImportObjects(_ jsonArray: [JSON]?, context: NSManagedObjectContext, success: (([Self]) -> Void), failure: ((Error) -> Void)? = nil, idKey: String = "id", save: Bool = true) {
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
                failure?(error)
                return
            }
            guard let object = getOrCreateObj else { return }
            CKLCoreData.shared.importJSON(from: objectJSON, toObject: object)
            objectsArray.append(object)
        }
        
        // Context Save
        
        if (save) {
//            asyncSave(context, {
//                success(objectsArray)
//            }, failure: failure)
            asyncSave(context, successCallback: {
                success(objectsArray)
            }, failure: failure)
        } else {
            success(objectsArray)
        }
    }
    
    static func asyncSave(_ context: NSManagedObjectContext, successCallback: (() -> ()), failure: ((Error) -> Void)? = nil) {
        do {
            try context.save()
            successCallback()
        } catch let error as NSError {
            // Error handling [Context Save]
            print("ERROR: \(error.localizedDescription)")  // TODO: turn on/off verbose option
            failure?(error)
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
