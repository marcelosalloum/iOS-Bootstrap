//
//  LoginCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func userDidClickForgotPassword()
}

class LoginCoordinator: Coordinator {
    private let presenter: UINavigationController

    private weak var loginViewController: LoginViewController?

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    override func start() {
        // View Model
        let viewModel = LoginViewModel()
        viewModel.coordinator = self

        // View Controller:
        guard let loginViewController = LoginViewController.fromStoryboard(.auth) else { return }
        loginViewController.viewModel = viewModel

        // Present View Controller:
        presenter.pushViewController(loginViewController, animated: true)
        setDeallocallable(with: loginViewController)
        self.loginViewController = loginViewController
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func userDidClickForgotPassword() {
        let forgotPasswordCoordinator = ForgotPasswordCoordinator(presenter: presenter)
        startCoordinator(forgotPasswordCoordinator)
    }
}
