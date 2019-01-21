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
/// Handles any kind of results
public enum EZCoreDataResult<Object> {
    /// Handles success results
    case success(result: Object?)
    
    /// Handles failure results
    case failure(error: Error)
}


// MARK: - Error Handling
/// Error Handling for the EZCoreData lib
enum EZCoreDataError: Error {
    /// Programmer has provided an empty JSON
    case jsonIsEmpty
    
    /// Object returned from `getOrCreate` method is surprisingly empty
    case getOrCreateObjIsEmpty
    
    /// The `idKey` provided is not available in the given NSManagedObject
    case invalidIdKey
}


// MARK: - Logging Handling
/// Printing Level
enum EZCoreDataLogLevel: String {
    /// Prints everything
    case info
    
    /// Prints only errors and warnings
    case warning
    
    /// Prints only errors
    case error
    
    /// Prints nothing
    case silent
}

struct EZCoreDataLogger {
    
    fileprivate static let libSuffix = "[EZCoreData]"
    
    /// Logging level. Can be any of the following: [info, warning, error, silent]
    static var logLevel = EZCoreDataLogLevel.info
    
    /// Loggs the given text if `logLevel == .info`
    static func log(_ logText: Any?) {
        if logLevel == .info {
            guard let text = logText else { return }
            print("\(libSuffix) INFO: \(text)")
        }
    }
    
    /// Loggs the given text if `logLevel in [.info, .warning]`
    static func logWarning(_ logText: Any?) {
        if [.info, .warning].contains(logLevel) {
            guard let text = logText else { return }
            print("\(libSuffix) WARNING: \(text)")
        }
    }
    
    /// Loggs the given text if `logLevel in [.info, .warning, .error]`
    static func logError(_ logText: Any?) {
        if [.info, .warning, .error].contains(logLevel) {
            guard let text = logText else { return }
            print("\(libSuffix) ERROR: \(text)")
        }
    }
}
