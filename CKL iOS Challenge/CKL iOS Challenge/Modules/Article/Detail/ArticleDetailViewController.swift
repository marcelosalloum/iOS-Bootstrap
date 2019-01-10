//
//  ArticleDetailViewController.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController, ArticleDetailProtocol {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    
    // MARK: - View Model
    let articleDetailViewModel = ArticleDetailViewModel()
    
    @IBAction func didSelectRightBarButtonItem(_ sender: UIBarButtonItem) {
        self.articleDetailViewModel.updateReadStatus(!articleDetailViewModel.article.wasRead)
    }
    
    func updateRightBarButtonItem(_ barButtonItem: UIBarButtonItem?) {
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    // MARK - View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.articleDetailViewModel.updateReadStatus(true)
        articleDetailViewModel.delegate = self
        setupView()
    }
    
    fileprivate func setupView() {
        guard let imageUrl = articleDetailViewModel.article.imageUrl else { return }
        guard let url = URL(string: imageUrl) else { return }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
        titleLabel?.text = articleDetailViewModel.article.title
        authorLabel?.text = articleDetailViewModel.article.authors
        contentLabel?.text = articleDetailViewModel.article.content
        timeLabel?.text = NSDate.timeAgoSince(articleDetailViewModel.article.date)
        //        tagsLabel?.text = article?.tags
        
        self.navigationItem.rightBarButtonItem = articleDetailViewModel.barButtonItem(for: articleDetailViewModel.article)
    }
}
