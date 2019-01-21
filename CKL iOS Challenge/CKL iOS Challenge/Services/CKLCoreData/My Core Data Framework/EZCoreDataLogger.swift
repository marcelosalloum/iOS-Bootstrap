//
//  CKLCoreData.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 09/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import CoreData
import UIKit


// MARK: - Result Handling
public enum EZCoreDataResult<Object> {
    case success(result: Object?)
    case failure(error: Error)
}


// MARK: - Error Handling
enum EZCoreDataError: Error {
    case contextIsEmpty
    case jsonIsEmpty
    case getOrCreateObjIsEmpty
    case invalidIdKey
}


// MARK: - Logging Handling
enum EZCoreDataLogLevel: String {
    case info
    case warning
    case error
    case silent
}

struct EZCoreDataLogger {
    
    fileprivate static let libSuffix = "[EZCoreData]"
    
    // Logging level
    static var logLevel = EZCoreDataLogLevel.info

    
    // Logging methods
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
