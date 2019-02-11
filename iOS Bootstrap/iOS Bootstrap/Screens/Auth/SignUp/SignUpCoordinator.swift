//
//  SignUpCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate: class {
    func userDidClickForgotPassword()
}

class SignUpCoordinator: Coordinator {
    private let presenter: UINavigationController
    private weak var signUpViewController: SignUpViewController?

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    override func start() {
        // View Model
        let viewModel = SignUpViewModel()
        viewModel.coordinator = self

        // View Controller:
        guard let signUpViewController = SignUpViewController.fromStoryboard(.auth) else { return }
        signUpViewController.viewModel = viewModel
//        viewModel.delegate = signUpViewController

        // Present View Controller:
        presenter.pushViewController(signUpViewController, animated: true)
        setDeallocallable(with: signUpViewController)
        self.signUpViewController = signUpViewController
    }
}

extension SignUpCoordinator: SignUpViewControllerDelegate {
    func userDidClickForgotPassword() {
        signUpViewController?.toastr("userDidClickForgotPassword")
    }
}
