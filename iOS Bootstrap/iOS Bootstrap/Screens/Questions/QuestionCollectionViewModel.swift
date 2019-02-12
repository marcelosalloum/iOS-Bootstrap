//
//  ArticleTableViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import EZCoreData

// MARK: - Protocol to comunicate from ViewModel o ViewController (MVVM)
protocol QuestionCollectionProtocol: class {
    func updateData(tags: [Tag], endRefreshing: Bool)
    func displayError(error: Error, endRefreshing: Bool)
    func displayMessage(_ message: String)
}

class QuestionCollectionViewModel: NSObject, ListViewModelProtocol {

    // MARK: - Initial Set-up
    var tags: [Tag] = []

    var ezCoreData: EZCoreData!

    weak var delegate: QuestionCollectionProtocol?

    weak var coordinator: ArticleTableViewControllerDelegate?

    override init() {
        super.init()

        // Observes offline mode
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ArticleTableViewModel.phoneIsOffline(notification:)),
                                               name: AppNotifications.PhoneIsOffline,
                                               object: nil)
    }

    deinit {
        // Deallocs observers
        NotificationCenter.default.removeObserver(self, name: AppNotifications.PhoneIsOffline, object: nil)
    }

    func userDidSelect(indexPath: IndexPath) {
    }

    func updateDataSource() {
        do {
            tags = try Tag.readAll(context: ezCoreData.mainThreadContext)
            DispatchQueue.main.async {
                self.delegate?.updateData(tags: self.tags, endRefreshing: true)
            }
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
    }

    // MARK: - GET Articles from API
    func fetchAPIData() {
        APIHelper.getArticlesList(ezCoreData.privateThreadContext) { (apiCompletion) in
            switch apiCompletion {
            case .success(result: let articleList):
                Article.deleteAll(except: articleList,
                                  backgroundContext: self.ezCoreData.privateThreadContext,
                                  completion: { _ in
                    self.updateDataSource()
                })
            case .failure(error: let error):
                DispatchQueue.main.async {
                    self.delegate?.displayError(error: error, endRefreshing: true)
                }
            }
        }
    }

    // MARK: - Offline modes
    @objc func phoneIsOffline(notification: Notification) {
        delegate?.displayMessage("No Internet Connection")
    }
}
