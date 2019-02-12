//
//  NewsCollectionViewController.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import PKHUD
//https://www.youtube.com/watch?v=Ko9oNhlTwH0
class NewsCollectionViewController: CoordinatedViewController {

    var viewModel: NewsCollectionViewModel!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Collection View
        collectionView.dataSource = self
        collectionView.delegate = self

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

extension NewsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.tags.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: UserTextCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! UserTextCollectionViewCell
        cell.articlesTag = NewsCollectionViewModel.getObject(from: viewModel.tags, with: indexPath)
        cell.coordinator = viewModel.coordinator
        return cell
    }
}

extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}

extension NewsCollectionViewController: NewsCollectionProtocol {
    func updateData(tags: [Tag], endRefreshing: Bool) {
        self.collectionView.reloadData()
    }

    func displayError(error: Error, endRefreshing: Bool) {
        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 2.0)
    }

    func displayMessage(_ message: String) {
        self.toastr(message)
    }
}
