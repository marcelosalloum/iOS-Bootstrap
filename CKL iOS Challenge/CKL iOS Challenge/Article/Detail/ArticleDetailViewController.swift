//
//  ArticleDetailViewController.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    @IBAction func didSelectRightBarButtonItem(_ sender: UIBarButtonItem) {
        var text = ""
        if let oldText = self.navigationItem.rightBarButtonItem?.title {
            text = oldText
        }
        
        text = (text == ReadState.markUnread.rawValue) ? ReadState.markRead.rawValue : ReadState.markUnread.rawValue
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: text, style: .plain, target: self, action: #selector(didSelectRightBarButtonItem(_: )))
    }
    
    var article: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView() {
        guard let imageUrl = article?.imageUrl else { return }
        guard let url = URL(string: imageUrl) else { return }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
        titleLabel?.text = article?.title
        authorLabel?.text = article?.authors
        contentLabel?.text = article?.content
        //        timeLabel?.text = article?.date
        //        tagsLabel?.text = article?.tags
    }
}
