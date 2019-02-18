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
        sender.animateTouchDown {
            let emailText = self.emailTextField.text
            let passText = self.passwordTextField.text
            let confirmPassText = self.passwordConfirmationTextField.text
            self.toastr("signUpButtonClicked with e-mail: \(emailText!), password: \(passText!)")
            self.viewModel.signUp(email: emailText,
                                  password: passText,
                                  passwordConfirmation: confirmPassText)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }
}
