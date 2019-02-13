//
//  LoginViewController.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class LoginViewController: CoordinatedViewController {

    var viewModel: LoginViewModel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordFied: UITextField!

    @IBAction func loginButtonClicked(_ sender: Any) {
        self.toastr("loginButtonClicked with -mail: \(emailField.text!), password: \(passwordFied.text!)")
        viewModel.login(email: emailField.text, password: passwordFied.text)
    }

    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        viewModel.userDidClickForgotPassword()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }
}
