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
protocol HUD {
    /// Shows a success message HUD
    func showSuccessHUD(message: String?, delay: TimeInterval)
    /// Shows a error message HUD
    func showErrorHUD(message: String?, delay: TimeInterval)
    /// Shows an info message HUD
    func showInfoHUD(message: String?, delay: TimeInterval)
    /// Shows a progress HUD
    func showProgressHUD(progress: Float, statusMessage: String?)
    /// Dismisses a HUD
    func dismissHUD(delay: TimeInterval)
}

extension HUD where Self: UIViewController {
    fileprivate func configHud() {
        SVProgressHUD.setBorderColor(.gray20)
        SVProgressHUD.setBorderWidth(0.5)
        SVProgressHUD.setBackgroundColor(UIColor(255, 255, 255, 0.3))
    }

    func showSuccessHUD(message: String?, delay: TimeInterval = 2) {
        configHud()
        SVProgressHUD.showSuccess(withStatus: message)
        SVProgressHUD.dismiss(withDelay: delay)
    }

    func showErrorHUD(message: String?, delay: TimeInterval = 2) {
        configHud()
        SVProgressHUD.showError(withStatus: message)
        SVProgressHUD.dismiss(withDelay: delay)
    }

    func showInfoHUD(message: String?, delay: TimeInterval = 2) {
        configHud()
        SVProgressHUD.showInfo(withStatus: message)
        SVProgressHUD.dismiss(withDelay: delay)
    }

    func showProgressHUD(progress: Float, statusMessage: String? = nil) {
        configHud()
        SVProgressHUD.showProgress(progress, status: statusMessage)
    }

    func dismissHUD(delay: TimeInterval = 0) {
        SVProgressHUD.dismiss(withDelay: delay)
    }
}
