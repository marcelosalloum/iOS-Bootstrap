//
//  Article+CoreDataProperties.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//
//

import Foundation
import CoreData

extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var authors: String?
    @NSManaged public var content: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var website: String?
    @NSManaged public var wasRead: Bool
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension Article {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
