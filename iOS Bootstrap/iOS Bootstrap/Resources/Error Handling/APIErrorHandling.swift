//
//  APIErrorHandling.swift
//  Glovo iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 05/03/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

/// Supported error status codes
enum ErrorStatusCode: Int {
    case silentError = 0
    case customError = 182
    case badRequestError = 400
    case unauthorizedError = 401
    case forbiddenError = 403
    case notFoundError = 404
    case timeoutError = 408
    case conflictError = 409
    case serverError = 500
}

/// This class is used to handle errors more easily
class CustomError: Error {

    var code = ErrorStatusCode.customError
    var localizedDescription: String = "Oops, something \n went wrong"
    var isCancelled = false

    required init(code: ErrorStatusCode = .customError, error: Error? = nil, localizedDescription: String? = nil) {
        self.code = code

        if let error = error {
            self.isCancelled = error.isCancelled
            self.code = error.isCancelled ? .silentError : code
            self.localizedDescription = error.localizedDescription
        }

        if let localizedDescription = localizedDescription {
            self.localizedDescription = localizedDescription
        }
    }
}
