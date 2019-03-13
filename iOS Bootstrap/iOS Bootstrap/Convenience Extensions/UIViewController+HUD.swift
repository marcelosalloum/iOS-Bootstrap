//
//  UIViewController+HUD.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 14/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import SVProgressHUD

/// This allows a ViewController to call a HUD (Head-Up Display) anytime.
/// It's encapsulated within this protocol, so a HUD lib can be easily replaced
protocol HUD: class {
    /// Shows a success message HUD
    func showSuccessHUD(message: String?, delay: TimeInterval)
    /// Shows a error message HUD
    func showErrorHUD(message: String?, delay: TimeInterval)
    /// Shows an info message HUD
    func showInfoHUD(message: String?, delay: TimeInterval)
    /// Shows a progress HUD
    func showProgressHUD(progress: Float, statusMessage: String?)
    /// Shows a loading HUD with an optional `message`
    func showLoadingHUD(message: String?)
    /// Dismisses a HUD
    func dismissHUD(delay: TimeInterval)
}

extension HUD where Self: UIViewController {

    /// Configures the HUD appearance
    fileprivate func configHud() {
        SVProgressHUD.setBorderColor(.lightGray)
        SVProgressHUD.setBorderWidth(0.5)
        SVProgressHUD.setBackgroundColor(UIColor(255, 255, 255, 0.3))
        SVProgressHUD.setDefaultMaskType(.black)
    }

    /// Shows a success message HUD
    func showSuccessHUD(message: String?, delay: TimeInterval = 3) {
        configHud()
        SVProgressHUD.showSuccess(withStatus: message)
        SVProgressHUD.dismiss(withDelay: delay)
    }

    /// Shows a error message HUD
    func showErrorHUD(message: String?, delay: TimeInterval = 3) {
        configHud()
        SVProgressHUD.showError(withStatus: message)
        SVProgressHUD.dismiss(withDelay: delay)
    }

    /// Shows an info message HUD
    func showInfoHUD(message: String?, delay: TimeInterval = 3) {
        configHud()
        SVProgressHUD.showInfo(withStatus: message)
        SVProgressHUD.dismiss(withDelay: delay)
    }

    /// Shows a progress HUD
    func showProgressHUD(progress: Float, statusMessage: String? = nil) {
        configHud()
        SVProgressHUD.showProgress(progress, status: statusMessage)
    }

    /// Shows a loading HUD with an optional `message`
    func showLoadingHUD(message: String?) {
        configHud()
        SVProgressHUD.show(withStatus: message)
        SVProgressHUD.dismiss(withDelay: 10)
    }

    /// Dismisses a HUD
    func dismissHUD(delay: TimeInterval = 0) {
        SVProgressHUD.dismiss(withDelay: delay)
    }
}
