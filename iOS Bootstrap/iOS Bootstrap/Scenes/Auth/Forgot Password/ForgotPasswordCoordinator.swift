//
//  ForgotPasswordCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

protocol ForgotPasswordViewControllerDelegate: class {
    func userDidClickForgotPassword()
}

class ForgotPasswordCoordinator: Coordinator {
    private let presenter: UINavigationController
    private weak var forgotPasswordViewController: ForgotPasswordViewController?

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    override func start() {
        // View Model
        let viewModel = ForgotPasswordViewModel()

        // View Controller:
        guard let forgotPasswordViewController = ForgotPasswordViewController.fromStoryboard(.auth) else { return }
        forgotPasswordViewController.viewModel = viewModel

        // Present View Controller:
        presenter.pushViewController(forgotPasswordViewController, animated: true)
        setDeallocallable(with: forgotPasswordViewController)
        self.forgotPasswordViewController = forgotPasswordViewController
    }
}
