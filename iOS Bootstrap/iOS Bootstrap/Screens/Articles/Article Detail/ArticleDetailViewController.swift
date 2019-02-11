//
//  ArticleDetailViewController.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 08/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class ArticleDetailViewController: CoordinatedViewController {

    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!

    // MARK: - View Model
    var viewModel: ArticleDetailViewModel!

    // MARK: - User Action
    @IBAction func didSelectRightBarButtonItem(_ sender: UIBarButtonItem) {
        self.viewModel.userSwitchedReadStatus()
    }

    // MARK: - View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
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

        resetRightBarButtonItem()
    }
}

extension ArticleDetailViewController: ArticleDetailProtocol {
    // MARK: - ArticleDetailProtocol
    func resetRightBarButtonItem(withText buttonText: String = ArticleState.markUnread) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: buttonText,
            style: .plain,
            target: self,
            action: #selector(ArticleDetailViewController.didSelectRightBarButtonItem(_:)))
    }
}
