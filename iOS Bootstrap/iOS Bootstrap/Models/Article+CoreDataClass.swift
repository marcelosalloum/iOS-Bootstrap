//
//  Article+CoreDataClass.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//
//

import Foundation
import CoreData
import EZCoreData

public class Article: NSManagedObject {
    /// Transfors the list of tagsinto a comma-separated string
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

extension Article {
    /// Populates Article objects from JSON
    override open func populateFromJSON(_ json: [String: Any], context: NSManagedObjectContext) {
        guard let rawId = json["id"], let id = Int16("\(rawId)") else { return }
        self.id = id
        self.authors = json["authors"] as? String
        self.content = json["content"] as? String
        self.imageUrl = json["image_url"] as? String
        self.title = json["title"] as? String
        self.website = json["website"] as? String

        if let dateString = json["date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"

            if let date = dateFormatter.date(from: dateString) as NSDate? {
                self.date = date
            }
        }

        if let tags = json["tags"] as? [[String: Any]] {
            do {
                guard let tagObjects = try Tag.importList(tags,
                                                          idKey: "id",
                                                          shouldSave: false,
                                                          context: context) else { return }
                let tagsSet = NSSet(array: tagObjects)
                self.addToTags(tagsSet)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
