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
    let viewModel = ArticleDetailViewModel()
    
    @IBAction func didSelectRightBarButtonItem(_ sender: UIBarButtonItem) {
        self.viewModel.updateReadStatus(!viewModel.article.wasRead)
    }
    
    func updateRightBarButtonItem(_ barButtonItem: UIBarButtonItem?) {
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    // MARK - View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.updateReadStatus(true)
        viewModel.delegate = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    fileprivate func setupView() {
        guard let imageUrl = viewModel.article.imageUrl else { return }
        guard let url = URL(string: imageUrl) else { return }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
        titleLabel?.text = viewModel.article.title
        authorLabel?.text = viewModel.article.authors
        contentLabel?.text = viewModel.article.content
        timeLabel?.text = NSDate.timeAgoSince(viewModel.article.date)
        tagsLabel?.text = viewModel.article.tagsToString()

        self.navigationItem.rightBarButtonItem = viewModel.barButtonItem(for: viewModel.article)
    }
}
