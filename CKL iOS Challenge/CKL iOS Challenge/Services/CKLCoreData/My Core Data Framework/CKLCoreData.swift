//
//  CKLCoreData.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 09/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import CoreData
import UIKit


enum CKLCoreDataError: Error {
    case contextIsEmpty
    case jsonIsEmpty
    case getOrCreateObjIsEmpty
    case invalidIdKey
}

enum CKLCoreDateLogLevel: String {
    case debug
    case silent
}


class CKLCoreData: NSObject {
    
    // Used by your project
    public static let shared = CKLCoreData()  // singleton

    // Used by the NSManagedObject extensions and your project
    static let context = CoreDataManager.shared.managedObjectContext
    
    // Logging level
    static var logLevel = CKLCoreDateLogLevel.debug
    
    static func log(_ logText: Any?) {
        switch logLevel {
        case .debug:
            guard let text = logText else { return }
            print(text)
            return
        case .silent:
            return
        }
    }
}
