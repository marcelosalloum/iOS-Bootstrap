//
//  UserTextCollectionViewCell.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 07/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class InnerCardCollectionViewCell: UICollectionViewCell {

    // MARK: - Injected Dependencies (Interface Builder included)
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!

    var article: Article! {
        didSet {
            setupSubviews()
        }
    }
}

// MARK: - Interface Setup & Customization
extension InnerCardCollectionViewCell {
    func setupSubviews() {
        // Set-up the cell content
        titleLabel.text = article.title
        timeLabel.text = NSDate.timeAgoSince(article.date, shortPattern: true)
        authorsLabel.text = article.authors
        updateWasReadStatus(article.wasRead)

        // Setup the cell image
        guard let imageURL = article.imageUrl else { return }
        guard let url = URL(string: imageURL) else { return }
        // Image Caching
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }

    func updateWasReadStatus(_ wasRead: Bool) {
        self.backgroundColor = wasRead ? UIColor.gray5() : UIColor.gray20()
    }
}
