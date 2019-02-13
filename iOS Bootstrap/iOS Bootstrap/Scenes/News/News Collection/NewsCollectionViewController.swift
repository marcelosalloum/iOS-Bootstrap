//
//  NewsCollectionViewController.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import PKHUD

class NewsCollectionViewController: CoordinatedViewController {

    // MARK: - Injected Dependencies (Interface Builder included)
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: NewsCollectionViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Collection View
        collectionView.dataSource = self
        collectionView.delegate = self

        // Nav Bar
        self.title = "Collection Sample"
    }

    override func viewWillAppear(_ animated: Bool) {
        // Nav Bar
        navigationController?.setNavigationBarHidden(false, animated: false)

        // View Model
        viewModel.updateDataSource()

        super.viewWillAppear(animated)
    }
}

// MARK: - Data Source
extension NewsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.tagsViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get Cell
        let cellId = String(describing: NewsFirstLevelCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! NewsFirstLevelCollectionViewCell
        // Configure Cell
        let cellViewModel = NewsCollectionViewModel.getObject(from: viewModel.tagsViewModels, with: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - Delegate
extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}

// MARK: - View Model: NewsCollectionViewDelegate
extension NewsCollectionViewController: NewsCollectionViewDelegate {
    func reloadData(endRefreshing: Bool) {
        self.collectionView.reloadData()
    }

    func displayError(error: Error, endRefreshing: Bool) {
        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 2.0)
    }

    func displayMessage(_ message: String) {
        self.toastr(message)
    }
}
