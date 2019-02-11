//
//  SignUpViewController.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class SignUpViewController: CoordinatedViewController {

    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    @IBOutlet weak var passwordConfirmationTextField: DesignableTextField!

    var viewModel: SignUpViewModel!

    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        self.toastr("signUpButtonClicked with -mail: \(emailTextField.text!), password: \(passwordTextField.text!)")
        viewModel.signUp(email: emailTextField.text,
                         password: passwordTextField.text,
                         passwordConfirmation: passwordConfirmationTextField.text)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }
}
