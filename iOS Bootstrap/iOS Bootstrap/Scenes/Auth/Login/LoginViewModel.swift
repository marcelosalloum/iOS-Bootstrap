//
//  SignUpViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 11/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {

    weak var coordinator: LoginViewControllerDelegate?

    func login(email: String?, password: String?) {
        print(email ?? "", password ?? "")
    }

    func userDidClickForgotPassword() {
        coordinator?.userDidClickForgotPassword()
    }
}
