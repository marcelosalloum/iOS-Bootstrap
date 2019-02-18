//
//  NewsTableViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import EZCoreData
import PromiseKit

class NewsCollectionViewModel: NSObject {
    // MARK: - Initial Set-up
    private var tags: [Tag] = [] {
        didSet {
            var newTagsViewModels = [InnerCollectionViewModel]()
            for tag in tags {
                let newChildModel = InnerCollectionViewModel()
                newChildModel.coordinator = coordinator
                newChildModel.articlesTag = tag
                newTagsViewModels.append(newChildModel)
            }
            self.tagsViewModels = newTagsViewModels
        }
    }
    var tagsViewModels: [InnerCollectionViewModel] = []

    var ezCoreData: EZCoreData!

    /// Delegate to ViewController
    weak var delegate: NewsCollectionViewDelegate?

    /// Coordinator delegate to Coordinator
    weak var coordinator: NewsInteractionProtocol?

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
        delegate?.displayMessage("NO_INTERNET_CONNECTION".localized)
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
                self.delegate?.reloadData(endRefreshing: true)
            }
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}

// MARK: - API Service: GET Articles (and Tags)
extension NewsCollectionViewModel {
    func fetchAPIData() {
        firstly { () -> Promise<[[String: Any]]> in
            APIService.getArticlesList(ezCoreData.privateThreadContext)
        }.then { json -> Promise<[Article]?> in
            Article.importList(json, idKey: Constants.idKey, backgroundContext: self.ezCoreData.privateThreadContext)
        }.then { importedArticles -> Promise<[Article]?> in
            Article.deleteAll(except: importedArticles, backgroundContext: self.ezCoreData.privateThreadContext)
        }.done { _ in
            self.updateDataSource()
        }.catch { error in
            self.delegate?.displayError(error: error, endRefreshing: true)
        }
    }
}
