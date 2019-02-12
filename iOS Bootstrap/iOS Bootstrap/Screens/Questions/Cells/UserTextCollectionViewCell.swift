//
//  UserTextCollectionViewCell.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 07/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class UserTextCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    var viewModel = InnerCollectionViewModel()

    weak var coordinator: NewsInteractionProtocol? {
        get {
            return viewModel.coordinator
        }
        set(newValue) {
            viewModel.coordinator = newValue
        }
    }

    var articlesTag: Tag! {
        get {
            return viewModel.articlesTag
        }
        set(newValue) {
            viewModel.articlesTag = newValue
            titleLabel.text = viewModel.articlesTag.label
            innerCollectionView.reloadData()
        }
    }

    @IBOutlet weak var innerCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        innerCollectionView.delegate = self
        innerCollectionView.dataSource = self
    }
}

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

extension UserTextCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.userDidSelect(indexPath: indexPath)
    }
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width * 2 / 3, height: 110)
//    }
}
