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

    init(presenter: UINavigationController, ezCoreData: EZCoreData) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
    }

    override func start() {
        // View Model
        let viewModel = QuestionCollectionViewModel()
        viewModel.ezCoreData = ezCoreData
        viewModel.coordinator = self

        // View Controller:
        guard let questionsCollectionViewController =
            QuestionsCollectionViewController.fromStoryboard(.collection) else { return }
        questionsCollectionViewController.viewModel = viewModel
        viewModel.delegate = questionsCollectionViewController

        // Present View Controller:
        presenter.pushViewController(questionsCollectionViewController, animated: true)
        setDeallocallable(with: questionsCollectionViewController)
        self.questionsCollectionViewController = questionsCollectionViewController
    }
}

// MARK: - ArticleTableViewControllerDelegate
extension QuestionsCollectionCoordinator: ArticleTableViewControllerDelegate {
    func articleTableViewControllerDidSelectArticle(_ selectedArticle: Article) {
        let articleDetailCoordinator = ArticleDetailCoordinator(presenter: presenter, article: selectedArticle)
        startCoordinator(articleDetailCoordinator)
    }
}
