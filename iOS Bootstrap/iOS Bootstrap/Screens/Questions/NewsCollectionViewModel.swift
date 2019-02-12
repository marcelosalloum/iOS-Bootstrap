//
//  NewsTableViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import EZCoreData

// MARK: - Protocol to comunicate from ViewModel o ViewController (MVVM)
protocol NewsCollectionProtocol: class {
    func updateData(tags: [Tag], endRefreshing: Bool)
    func displayError(error: Error, endRefreshing: Bool)
    func displayMessage(_ message: String)
}

class NewsCollectionViewModel: NSObject {
    // MARK: - Initial Set-up
    var tags: [Tag] = []

    var ezCoreData: EZCoreData!

    /// Delegate to ViewController
    weak var delegate: NewsCollectionProtocol?

    /// Coordinator delegate to Coordinator
    weak var coordinator: ArticleInteractionProtocol?

    // MARK: - Observe for Offline mode
    override init() {
        super.init()
        startWatchingOfflineMode()
    }

    deinit {
        stopWatchingOfflineMode()
    }
}

// MARK: - Offline mode
extension NewsCollectionViewModel: ObserveOfflineProtocol {
    @objc func handleOfflineSituation() {
        delegate?.displayMessage("No Internet Connection")
    }
}

// MARK: - User Selected index path
extension NewsCollectionViewModel: ListViewModelProtocol {
    func userDidSelect(indexPath: IndexPath) { }
}

// MARK: - Core Data Service: GET Tags (and Articles)
extension NewsCollectionViewModel {
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
}

// MARK: - API Service: GET Articles (and Tags)
extension NewsCollectionViewModel {
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
}
