//
//  NewsTableViewCell.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    // MARK: - Injected Dependencies
    @IBOutlet weak var newsContentView: NewsCardView!

    var article: Article! {
        didSet {
            setupSubviews()
        }
    }
}

// MARK: - Interface Setup & Customization
extension NewsTableViewCell {
    func setupSubviews() {
        // Set-up the cell content
        newsContentView.titleLabel.text = article.title
        newsContentView.timeLabel.text = NSDate.timeAgoSince(article.date, shortPattern: true)
        newsContentView.authorsLabel.text = article.authors
        updateWasReadStatus(article.wasRead)

        // Setup the cell image
        guard let imageURL = article.imageUrl else { return }
        guard let url = URL(string: imageURL) else { return }
        // Image Caching
        newsContentView.imageView.kf.indicatorType = .activity
        newsContentView.imageView.kf.setImage(with: url)
    }

    func updateWasReadStatus(_ wasRead: Bool) {
        self.backgroundColor = wasRead ? UIColor.gray5 : UIColor.gray20
    }
}
