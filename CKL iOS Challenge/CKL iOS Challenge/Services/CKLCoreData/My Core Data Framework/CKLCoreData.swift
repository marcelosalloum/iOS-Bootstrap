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
    case info
    case warning
    case error
    case silent
}


struct CKLCoreData {
    
    fileprivate static let libSuffix = "[CKLCoreData]"
    
    // Logging level
    static var logLevel = CKLCoreDateLogLevel.info
    
    static func log(_ logText: Any?) {
        if logLevel == .info {
            guard let text = logText else { return }
            print("\(libSuffix) INFO: \(text)")
        }
    }
    
    static func logWarning(_ logText: Any?) {
        if [.info, .warning].contains(logLevel) {
            guard let text = logText else { return }
            print("\(libSuffix) WARNING: \(text)")
        }
    }
    
    static func logError(_ logText: Any?) {
        if [.info, .warning, .error].contains(logLevel) {
            guard let text = logText else { return }
            print("\(libSuffix) ERROR: \(text)")
        }
    }
}
