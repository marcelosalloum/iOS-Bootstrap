//
//  UIViewController+Toastr.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 04/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Displays a simple toastr in the ViewController
    func toastr(_ message: String, delay: Double = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            alert.dismiss(animated: true)
        }
    }

}
