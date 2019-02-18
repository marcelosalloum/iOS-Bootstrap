//
//  NewsFirstLevelCollectionViewCell.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 07/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class NewsFirstLevelCollectionViewCell: UICollectionViewCell {

    // MARK: - Injected Dependencies
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var innerCollectionView: UICollectionView!

    var viewModel: InnerCollectionViewModel! {
        didSet {
            setupSubviews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Collection View
        innerCollectionView.delegate = self
        innerCollectionView.dataSource = self
    }
}

// MARK: - Interface Setup & Customization
extension NewsFirstLevelCollectionViewCell {
    /// Setup Subview(s)
    func setupSubviews() {
        // titleLabel
        titleLabel.text = viewModel.articlesTag.label
        innerCollectionView.reloadData()
    }
}

// MARK: - Data Source
extension NewsFirstLevelCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: NewsSecondLevelCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! NewsSecondLevelCollectionViewCell
        cell.article = InnerCollectionViewModel.getObject(from: viewModel.articles, with: indexPath)

        return cell
    }
}

// MARK: - Delegate
extension NewsFirstLevelCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewsSecondLevelCollectionViewCell else { return }
        cell.animateTouchDown().done {
            self.viewModel.userDidSelect(indexPath: indexPath)
        }
    }
}
