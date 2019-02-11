//
//  WelcomeCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 11/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

protocol WelcomeViewControllerDelegate: class {
    func userDidSelectStoryboard(_ storyboardName: StoryboardName)
}

class WelcomeCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData

    private weak var welcomeViewController: WelcomeViewController?

    init(presenter: UINavigationController, ezCoreData: EZCoreData) {
        self.presenter  = presenter
        self.ezCoreData = ezCoreData
    }

    override func start() {
        // View Model
        let viewModel = WelcomeViewModel()
        viewModel.coordinator = self

        // View Controller:
        guard let welcomeViewController   = WelcomeViewController.fromStoryboard(.welcome) else { return }
        welcomeViewController.viewModel   = viewModel

        // Present View Controller:
        presenter.pushViewController(welcomeViewController, animated: true)
        setDeallocallable(with: welcomeViewController)
        self.welcomeViewController = welcomeViewController
    }
}

extension WelcomeCoordinator: WelcomeViewControllerDelegate {
    func userDidSelectStoryboard(_ storyboardName: StoryboardName) {
        switch storyboardName {
        case .news:
            setupArticleListScreen()
        case .auth:
            setupAuthHomeCoordinator()
        case .collection:
            setupQuestionsCollectionScreen()
        default:
            break
        }

    }

    fileprivate func setupQuestionsCollectionScreen() {
        // Setups QuestionsCollectionCoordinator
        let questionsCollectionCoordinator = QuestionsCollectionCoordinator(presenter: presenter)
        startCoordinator(questionsCollectionCoordinator)
    }

    fileprivate func setupArticleListScreen() {
        // Setups ArticleTableCoordinator
        let articleTableCoordinator = ArticleTableCoordinator(presenter: presenter, ezCoreData: ezCoreData)
        startCoordinator(articleTableCoordinator)
    }

    fileprivate func setupAuthHomeCoordinator() {
        // Setups ArticleTableCoordinator
        let authHomeCoordinator = AuthHomeCoordinator(presenter: presenter, ezCoreData: ezCoreData)
        startCoordinator(authHomeCoordinator)
    }
}
