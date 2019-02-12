//
//  QuestionsCollectionCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

protocol QuestionsCollectionViewControllerDelegate: class {
    func userDidClickLogin()
    func userDidClickSignUp()
}

class QuestionsCollectionCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData

    private weak var questionsCollectionViewController: QuestionsCollectionViewController?
    private var loginCoordinator: LoginCoordinator?
    private var signUpCoordinator: SignUpCoordinator?

    init(presenter: UINavigationController, ezCoreData: EZCoreData) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
    }

    override func start() {
        // View Model
        let viewModel = QuestionCollectionViewModel()
        viewModel.ezCoreData = ezCoreData

        // View Controller:
        guard let questionsCollectionViewController =
            QuestionsCollectionViewController.fromStoryboard(.collection) else { return }
        questionsCollectionViewController.viewModel = viewModel
        viewModel.delegate = questionsCollectionViewController
        questionsCollectionViewController.coordinator = self

        // Present View Controller:
        presenter.pushViewController(questionsCollectionViewController, animated: true)
        setDeallocallable(with: questionsCollectionViewController)
        self.questionsCollectionViewController = questionsCollectionViewController
    }
}

extension QuestionsCollectionCoordinator: QuestionsCollectionViewControllerDelegate {
    func userDidClickLogin() {
        let loginCoordinator = LoginCoordinator(presenter: presenter)
        loginCoordinator.start()
        loginCoordinator.stop = {
            self.loginCoordinator = nil
        }
        self.loginCoordinator = loginCoordinator

    }

    func userDidClickSignUp() {
        let signUpCoordinator = SignUpCoordinator(presenter: presenter)
        signUpCoordinator.start()
        signUpCoordinator.stop = {
            self.signUpCoordinator = nil
        }
        self.signUpCoordinator = signUpCoordinator
    }
}
