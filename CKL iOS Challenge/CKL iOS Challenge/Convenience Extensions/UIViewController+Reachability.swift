//
//  UIViewController+Reachability.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 14/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


struct AppNotifications {
    static let PhoneIsOffline = Notification.Name("PhoneIsOffline")
    static let PhoneIsOnline = Notification.Name("PhoneIsOnline")
}

extension UIViewController {
    static let reachabilityManager = NetworkReachabilityManager()
    static func setupReachability() {
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { _ in
            if let isNetworkReachable = self.reachabilityManager?.isReachable, isNetworkReachable == true {
                NotificationCenter.default.post(name: AppNotifications.PhoneIsOnline, object: nil)
            } else {
                NotificationCenter.default.post(name: AppNotifications.PhoneIsOffline, object: nil)
            }
        }
    }
}
