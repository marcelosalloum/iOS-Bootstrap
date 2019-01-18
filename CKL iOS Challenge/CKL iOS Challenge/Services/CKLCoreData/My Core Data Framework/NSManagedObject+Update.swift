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
    @objc func populateFromJSON(_ json: [String: Any]) {
        print("NSManagedObject")
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
        } catch let error as NSError {
            CKLCoreData.log("ERROR: \(error.localizedDescription)")
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
        guard let jsonArray = jsonArray else { throw CKLCoreDataError.contextIsEmpty }
        if jsonArray.isEmpty { throw CKLCoreDataError.jsonIsEmpty }
        var objectsArray: [Self] = []

        // Basic CoreData Setup
        let fetchRequest = syncFetchRequest(inContext: context)

        // Looping over the array
        for objectJSON in jsonArray {
            // GET or CREATE
            guard let objectId = objectJSON[idKey] as? Int else { throw CKLCoreDataError.invalidIdKey }
            guard let object = getOrCreate(context: context, attribute: idKey, value: String(describing: objectId)) else { throw CKLCoreDataError.getOrCreateObjIsEmpty }
            object.populateFromJSON(objectJSON)
            objectsArray.append(object)
        }

        // Context Save
        if (shouldSave) {
            try save(context)
        }
        return objectsArray
    }
    
    // TODO
    public static func asyncImportObjects(_ jsonArray: [[String: Any]]?, context: NSManagedObjectContext, completion: @escaping (AwesomeDataResult<[Self]>) -> (), idKey: String = "id") {
        // Input validations
        guard let jsonArray = jsonArray else { return }
        if jsonArray.isEmpty { return }
        var objectsArray: [Self] = []
        
        // Basic CoreData Setup
        let fetchRequest = syncFetchRequest(inContext: context)
        
        // Looping over the array
        for objectJSON in jsonArray {
            
            // GET or CREATE
            guard let objectId = objectJSON[idKey] as? Int else { return }
            guard let object = self.getOrCreate(context: context, fetchRequest: fetchRequest, attribute: idKey, value: String(describing: objectId)) else {
                completion(AwesomeDataResult<[Self]>.failure(error: CKLCoreDataError.getOrCreateObjIsEmpty))
                return
            }
            object.populateFromJSON(objectJSON)
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
