//
//  ArticleTableViewCell.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    var article: Article! {
        didSet {
            // Set-up the cell content
            titleLabel.text = article.title
            timeLabel.text = NSDate.timeAgoSince(article.date, shortPattern: true)
            authorLabel.text = article.authors
            updateWasReadStatus(article.wasRead)

            // Setup the cell image
            guard let imageURL = article.imageUrl else { return }
            guard let url = URL(string: imageURL) else { return }
            // Image Caching
            articleImageView.kf.indicatorType = .activity
            articleImageView.kf.setImage(with: url)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateWasReadStatus(_ wasRead: Bool) {
        self.backgroundColor = wasRead ? UIColor.gray5() : UIColor.gray20()
    }
}
