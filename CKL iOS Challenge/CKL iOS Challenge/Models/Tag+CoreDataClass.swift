//
//  Tag+CoreDataClass.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//
//

import Foundation
import CoreData


public class Tag: NSManagedObject {
    
}


extension Tag {
    override public func populateFromJSON(_ json: [String: Any]) {
        guard let id = json["id"] as? Int16 else { return }
        self.id = id
        self.label = json["label"] as? String
    }
}
