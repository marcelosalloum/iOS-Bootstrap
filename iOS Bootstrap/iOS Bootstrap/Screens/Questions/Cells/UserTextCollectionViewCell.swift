//
//  UserTextCollectionViewCell.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 07/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class UserTextCollectionViewCell: UICollectionViewCell {

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
extension UserTextCollectionViewCell {
    /// Setup Subview(s)
    func setupSubviews() {
        // titleLabel
        titleLabel.text = viewModel.articlesTag.label
        innerCollectionView.reloadData()
    }
}

// MARK: - Data Source
extension UserTextCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: InnerCardCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! InnerCardCollectionViewCell
        cell.article = InnerCollectionViewModel.getObject(from: viewModel.articles, with: indexPath)

        return cell
    }
}

// MARK: - Delegate
extension UserTextCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.userDidSelect(indexPath: indexPath)
    }
}
