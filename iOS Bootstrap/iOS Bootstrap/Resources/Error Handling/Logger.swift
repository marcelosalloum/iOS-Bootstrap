//
//  Logger.swift
//  Glovo iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 05/03/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

// MARK: - Logging Handling
/// Printing Level
public enum LogLevel: Int {
    /// Prints nothing
    case none = 0

    /// Prints only errors
    case error = 1

    /// Prints only errors and warnings
    case warning = 2

    /// Prints everything
    case info = 3
}

/// A struct used to handle logs and change the log level easily
public struct Logger {

    fileprivate static let prefixName = "[Glovo iOS]"

    /// Authorized Logging level. Can be any of the following: [none, error, warning, info]
    static var allowedVerbose = LogLevel.info

    /// Prints `logText` if `verboseLevel > authorizedVerbose`
    static func log(_ logText: Any?, verboseLevel: LogLevel = .info) {
        guard let text = logText else { return }
        if verboseLevel.rawValue > self.allowedVerbose.rawValue { return }
        print("\(prefixName) \(String(describing: verboseLevel).uppercased()): \(text)")
    }
}
