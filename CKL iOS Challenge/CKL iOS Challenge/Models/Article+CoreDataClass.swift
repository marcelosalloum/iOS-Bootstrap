//
//  Article+CoreDataClass.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//
//

import Foundation
import CoreData


public class Article: NSManagedObject {
    func tagsToString() -> String {
        
        guard let tags = self.tags else { return "" }
        if tags.count == 0 { return "" }
        guard let tagsArray = tags.allObjects as? [Tag] else { return "" }
        
        var stringfiedTags = ""
        for tag in tagsArray {
            guard let label = tag.label else { continue }
            if stringfiedTags.count > 0 {
                stringfiedTags += ", "
            }
            stringfiedTags += label
        }
        
        return stringfiedTags
    }
}
