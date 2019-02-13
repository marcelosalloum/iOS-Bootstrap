//
//  AuthHomeCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

protocol AuthHomeViewControllerDelegate: class {
    func userDidClickLogin()
    func userDidClickSignUp()
}

class AuthHomeCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData!

    private weak var authHomeViewController: AuthHomeViewController?

    init(presenter: UINavigationController, ezCoreData: EZCoreData) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
    }

    override func start() {
        // View Controller:
        guard let authHomeViewController = AuthHomeViewController.fromStoryboard(.auth) else { return }
        authHomeViewController.coordinator = self

        // Present View Controller:
        presenter.pushViewController(authHomeViewController, animated: true)
        setDeallocallable(with: authHomeViewController)
        self.authHomeViewController = authHomeViewController
    }
}

extension AuthHomeCoordinator: AuthHomeViewControllerDelegate {
    func userDidClickLogin() {
        let loginCoordinator = LoginCoordinator(presenter: presenter)
        startCoordinator(loginCoordinator)
    }

    func userDidClickSignUp() {
        let signUpCoordinator = SignUpCoordinator(presenter: presenter)
        startCoordinator(signUpCoordinator)
    }
}
