//
//  Tag+CoreDataClass.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//
//

import Foundation
import CoreData
import EZCoreData

public class Tag: NSManagedObject {

}

extension Tag {
    /// Populates Tag objects from JSON
    override open func populateFromJSON(_ json: [String: Any], context: NSManagedObjectContext) {
        guard let id = json["id"] as? Int16 else { return }
        self.id = id
        self.label = json["label"] as? String
    }
}
