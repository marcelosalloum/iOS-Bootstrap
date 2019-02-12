//
//  ObserveOfflineProtocol.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 12/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Reachability Notifications
struct ReachabilityNotifications {
    static let PhoneIsOffline = Notification.Name("PhoneIsOffline")
    static let PhoneIsOnline = Notification.Name("PhoneIsOnline")
}

// MARK: -
/// **Enable Reachability**
/// When you implement this module, remember to instantiate your `reachabilityManager`
/// This will make yourr class throw app Notifications when your phone's switches between
/// online/offline modes.
protocol EnableReachabilityProtocol {
    static var reachabilityManager: NetworkReachabilityManager? { get }
    static func setupReachability()
}

extension EnableReachabilityProtocol {
    static func setupReachability() {
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { _ in
            if let isNetworkReachable = self.reachabilityManager?.isReachable, isNetworkReachable == true {
                NotificationCenter.default.post(name: ReachabilityNotifications.PhoneIsOnline, object: nil)
            } else {
                NotificationCenter.default.post(name: ReachabilityNotifications.PhoneIsOffline, object: nil)
            }
        }
    }
}

// MARK: - Should be implemented in ViewControllers that deal/care with offline mode transition
/// This method should be implemented in ViewControllers that deal/care with offline mode transition
/// Method `handleOfflineSituation` needs to be implemented to deal with offline transition
protocol ObserveOfflineProtocol: class {
    func startWatchingOfflineMode()
    func stopWatchingOfflineMode()
    func handleOfflineSituation()
}

extension ObserveOfflineProtocol {
    /// Calls method `handleOfflineSituation` when phone goes offline
    /// Don't forget too call `stopWatchingOfflineMode` from `dinit`, if you have started observing it
    func startWatchingOfflineMode() {
        // Observes offline mode
        NotificationCenter.default.addObserver(self,
                                               selector: Selector("handleOfflineSituation"),
                                               name: ReachabilityNotifications.PhoneIsOffline,
                                               object: nil)
    }

    /// Should be called in the deinit method
    func stopWatchingOfflineMode() {
        // Deallocs observers
        NotificationCenter.default.removeObserver(self, name: ReachabilityNotifications.PhoneIsOffline, object: nil)
    }
}

// MARK: - Should be implemented in ViewControllers that deal/care with online mode transition
/// This method should be implemented in ViewControllers that deal/care with online mode transition
/// Method `handleOnlineSituation` needs to be implemented to deal with online transition
protocol ObserveOnlineProtocol: class {
    func startWatchingOnlineMode()
    func stopWatchingOnlineMode()
    func handleOnlineSituation()
}

extension ObserveOnlineProtocol {
    /// Calls method `handleOnlineSituation` when phone goes online
    /// Don't forget too call `stopWatchingOnlineMode` from `dinit`, if you have started observing it
    func startWatchingOnlineMode() {
        // Observes offline mode
        NotificationCenter.default.addObserver(self,
                                               selector: Selector("handleOnlineSituation"),
                                               name: ReachabilityNotifications.PhoneIsOnline,
                                               object: nil)
    }

    /// Should be called in the deinit method
    func stopWatchingOnlineMode() {
        // Deallocs observers
        NotificationCenter.default.removeObserver(self, name: ReachabilityNotifications.PhoneIsOnline, object: nil)
    }
}

/// A protocol that can watch both Offline and Online transitions to handle them
///
/// You should implement methods `handleOnlineSituation` and `handleOfflineSituation` accordingly
typealias ObserveConectivityProtocol = ObserveOfflineProtocol & ObserveOnlineProtocol
