//
//  SignUpViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 11/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class SignUpViewModel: NSObject {

    weak var coordinator: SignUpViewControllerDelegate?

    func signUp(email: String?, password: String?, passwordConfirmation: String?) {
        print(email ?? "", password ?? "", passwordConfirmation ?? "")
    }
}
