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
    /// All NSManagedObject children need to override this
    @objc func populateFromJSON(_ json: [String: Any], context: NSManagedObjectContext) {
        fatalError("\n\n [EZCoreData] FATAL ERROR!!!  ATTENTION, YOU MUST OVERRIDE METHOD populateFromJSON(_ json: [String: Any], context: NSManagedObjectContext) IN YOUR NSManagedObject subclasses!!! \n\n")
    }
}


extension NSFetchRequestResult where Self: NSManagedObject {
    
    
    // MARK: - Get or Create
    /// GET or CREATE object with `attribute` equals `value`
    public static func getOrCreate(attribute: String?, value: String?, context: NSManagedObjectContext) -> Self? {
        // Initializing return variables
        var object: Self!
        var fetchedObjects: [Self] = []
        
        // GET, if idKey exists
        do {
            fetchedObjects = try readAllByAttribute(attribute, value: value, context: context)
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
}


// MARK: - Import from JSON
extension NSFetchRequestResult where Self: NSManagedObject {
    /// SYNC Import JSON Dict to Object
    public static func importObject(_ jsonObject: [String: Any]?,
                                    idKey: String = "id",
                                    shouldSave: Bool,
                                    context: NSManagedObjectContext = EZCoreData.mainThredContext) throws -> Self {
        guard let jsonObject = jsonObject else { throw EZCoreDataError.jsonIsEmpty }
        guard let objectId = jsonObject[idKey] as? Int else { throw EZCoreDataError.invalidIdKey }
        guard let object = getOrCreate(attribute: idKey, value: String(describing: objectId), context: context) else { throw EZCoreDataError.getOrCreateObjIsEmpty }
        object.populateFromJSON(jsonObject, context: context)
        // Context Save
        if (shouldSave) {
            context.saveContextToStore()
        }
        return object
    }
    
    /// SYNC import a JSON array into a list of objects and then save them to CoreData
    public static func importList(_ jsonArray: [[String: Any]]?,
                                  idKey: String = "id",
                                  shouldSave: Bool,
                                  context: NSManagedObjectContext = EZCoreData.mainThredContext) throws -> [Self]? {
        // Input validations
        guard let jsonArray = jsonArray else { throw EZCoreDataError.jsonIsEmpty }
        if jsonArray.isEmpty { throw EZCoreDataError.jsonIsEmpty }
        var objectsArray: [Self] = []

        // Looping over the array then GET or CREATE
        for objectJSON in jsonArray {
            let object = try importObject(objectJSON, idKey: idKey, shouldSave: false, context: context)
            objectsArray.append(object)
        }

        // Context Save
        if (shouldSave) {
            context.saveContextToStore()
        }
        return objectsArray
    }
    
    /// ASYNC import a JSON array into a list of objects and then save them to CoreData
    public static func importList(_ jsonArray: [[String: Any]]?,
                                  idKey: String = "id",
                                  backgroundContext: NSManagedObjectContext = EZCoreData.privateThreadContext,
                                  completion: @escaping (EZCoreDataResult<[Self]>) -> ()) {
        backgroundContext.perform {
            // Input validations
            guard let jsonArray = jsonArray else { return }
            if jsonArray.isEmpty { return }
            var objectsArray: [Self] = []
            
            // Looping over the array then GET or CREATE
            for objectJSON in jsonArray {
                do {
                    let object = try importObject(objectJSON, idKey: idKey, shouldSave: false, context: backgroundContext)
                    objectsArray.append(object)
                } catch let error {
                    completion(EZCoreDataResult<[Self]>.failure(error: error))
                }
            }
            
            // Context Save
            EZCoreData.shared.saveChanges()
            completion(EZCoreDataResult<[Self]>.success(result: objectsArray))
        }
    }
}
