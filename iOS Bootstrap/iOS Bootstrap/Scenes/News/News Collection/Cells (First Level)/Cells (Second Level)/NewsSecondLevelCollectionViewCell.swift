//
//  NewsFirstLevelCollectionViewCell.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 07/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class NewsSecondLevelCollectionViewCell: UICollectionViewCell {

    // MARK: - Injected Dependencies (Interface Builder included)
    @IBOutlet weak var newsCardView: NewsCardView!

    var article: Article! {
        didSet {
            setupSubviews()
        }
    }
}

// MARK: - Interface Setup & Customization
extension NewsSecondLevelCollectionViewCell {
    func setupSubviews() {
        // Set-up the cell content
        newsCardView.titleLabel.text = article.title
        newsCardView.timeLabel.text = NSDate.timeAgoSince(article.date, shortPattern: true)
        newsCardView.authorsLabel.text = article.authors
        updateWasReadStatus(article.wasRead)

        // Setup the cell image
        guard let imageURL = article.imageUrl else { return }
        guard let url = URL(string: imageURL) else { return }
        // Image Caching
        newsCardView.imageView.kf.indicatorType = .activity
        newsCardView.imageView.kf.setImage(with: url)
    }

    func updateWasReadStatus(_ wasRead: Bool) {
        self.backgroundColor = wasRead ? UIColor.gray5 : UIColor.gray20
    }
}
