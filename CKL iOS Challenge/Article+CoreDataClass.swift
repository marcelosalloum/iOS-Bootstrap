//
//  Article+CoreDataClass.swift
//  
//
//  Created by Marcelo Salloum dos Santos on 07/01/19.
//
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {
}

public protocol CKLCoreDataProtocol {
    static func importJSON(from: Any, toObject: NSManagedObject)
}

extension Article: CKLCoreDataProtocol {
//    public static func importJSON(from: Any, toObject: NSManagedObject) {
//        print("DEF")
//    }
}
