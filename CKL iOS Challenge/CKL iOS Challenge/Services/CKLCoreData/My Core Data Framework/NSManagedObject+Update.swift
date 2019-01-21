//
//  NSManagedObject+Update.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import CoreData


// MARK: - Used for importing a JSON into an NSManagedObjectContext
extension NSManagedObject {
    @objc func populateFromJSON(_ json: [String: Any], context: NSManagedObjectContext) {
        fatalError("\n\n ATTENTION, YOU MUST OVERRIDE METHOD populateFromJSON(_ json: [String: Any], context: NSManagedObjectContext) IN YOUR NSManagedObject subclasses!!! \n\n")
    }
}


extension NSFetchRequestResult where Self: NSManagedObject {
    
    
    // MARK: - Get or Create
    public static func getOrCreate(context: NSManagedObjectContext, attribute: String?, value: String?) -> Self? {
        // Initializing return variables
        var object: Self!
        var fetchedObjects: [Self] = []
        
        // GET, if idKey exists
        do {
            fetchedObjects = try readAwesome(inContext: context, attribute: attribute, value: value, sortDescriptors: nil)
        } catch let error {
            EZCoreDataLogger.logError(error.localizedDescription)
            return nil
        }
        
        // CREATE if idKey doesn't exist
        if (fetchedObjects.count > 0) {
            object = fetchedObjects[0]
        } else {
            object = Self.init(entity: self.entity(), insertInto: context)
        }
        
        return object
    }
    
    // MARK: - Import from JSON
    public static func importList(_ jsonArray: [[String: Any]]?, context: NSManagedObjectContext, idKey: String = "id", shouldSave: Bool) throws -> [Self]? {
        // Input validations
        guard let jsonArray = jsonArray else { throw EZCoreDataError.jsonIsEmpty }
        if jsonArray.isEmpty { throw EZCoreDataError.jsonIsEmpty }
        var objectsArray: [Self] = []

        // Looping over the array
        for objectJSON in jsonArray {
            // GET or CREATE
            guard let objectId = objectJSON[idKey] as? Int else { throw EZCoreDataError.invalidIdKey }
            guard let object = getOrCreate(context: context, attribute: idKey, value: String(describing: objectId)) else { throw EZCoreDataError.getOrCreateObjIsEmpty }
            object.populateFromJSON(objectJSON, context: context)
            objectsArray.append(object)
        }

        // Context Save
        if (shouldSave) {
            try save(context)
        }
        return objectsArray
    }
    
    public static func asyncImportObjects(_ jsonArray: [[String: Any]]?, backgroundContext: NSManagedObjectContext, completion: @escaping (EZCoreDataResult<[Self]>) -> (), idKey: String = "id") {
        backgroundContext.perform {
            // Input validations
            guard let jsonArray = jsonArray else { return }
            if jsonArray.isEmpty { return }
            var objectsArray: [Self] = []
            
            // Looping over the array
            for objectJSON in jsonArray {
                
                // GET or CREATE
                guard let objectId = objectJSON[idKey] as? Int else { return }
                guard let object = self.getOrCreate(context: backgroundContext, attribute: idKey, value: String(describing: objectId)) else {
                    completion(EZCoreDataResult<[Self]>.failure(error: EZCoreDataError.getOrCreateObjIsEmpty))
                    return
                }
                object.populateFromJSON(objectJSON, context: backgroundContext)
                objectsArray.append(object)
            }
            
            // Context Save
            EZCoreData.shared.saveChanges()
            completion(EZCoreDataResult<[Self]>.success(objectList: objectsArray))
        }
    }
}
