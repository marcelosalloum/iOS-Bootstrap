//
//  UIViewController+ErrorHandling.swift
//  Glovo iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 08/03/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

/// A ViewController that calls method `onDeinit` when being deallocated.
/// This will ensure the coordinator is being deallocated as well
extension UIViewController: ErrorHandler, HUD {

    /// Handles the error of type ErrorStatus
    func handleError(_ error: Error) {
        if let err = error as? CustomError {
            if err.code == .silentError { return }
            showErrorHUD(message: err.localizedDescription)
        } else if !error.isCancelled {
            showErrorHUD(message: error.localizedDescription)
        } else {
            dismissHUD()
        }
    }
}

/// Handles the error of type ErrorStatus
protocol ErrorHandler: class {
    /// Handles the error of type ErrorStatus
    func handleError(_ error: Error)
}
