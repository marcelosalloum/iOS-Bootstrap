//
//  CKLCoreData.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 09/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import CoreData
import UIKit
import SwiftyJSON


protocol ParseJSONToEntityProtocol {
    func importDict(from: JSON, toObject: NSManagedObject)
}

class CKLCoreData: NSObject {
    public static let shared = CKLCoreData() // singleton

    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var jsonMappingDicts = [String: [String: String]]()
    
//    func registerJSONMapping<T>(t: T.Type, dict: [String: String]?) -> Void {
//        let dictKey: String = String(describing: t)
//        jsonMappingDicts[dictKey] = dict
//    }
    
    func importJSON(from: JSON, toObject: NSManagedObject) {
        let objectClass: String = String(describing: type(of: toObject))
        switch objectClass {
        case String(describing: Article.self):
            print("Article")
            if let article = toObject as? Article {
                importArticle(from: from, toObject: article)
            }
        case String(describing: Tag.self):
            print("Tag")
        default:
            print("None")
        }
    }
    
    func importArticle(from: JSON, toObject: Article) {
        if let id = from["id"].int16 {
            toObject.id = id
        }
        if let authors = from["authors"].string {
            toObject.authors = authors
        }
        if let content = from["content"].string {
            toObject.content = content
        }
        if let dateString = from["date"].string {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            
            if let date = dateFormatter.date(from: dateString) {
                toObject.date = date
            }
        }
        if let imageUrl = from["image_url"].string {
            toObject.imageUrl = imageUrl
        }
        if let title = from["title"].string {
            toObject.title = title
        }
        if let website = from["website"].string {
            toObject.website = website
        }
    }
    
//    static func importJSON(from: JSON, toObject: Self) {
}
