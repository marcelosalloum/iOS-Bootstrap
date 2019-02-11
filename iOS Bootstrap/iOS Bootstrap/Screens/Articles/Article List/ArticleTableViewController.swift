//
//  ArticleTableViewController.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher

class ArticleTableViewController: CoordinatedViewController, UISearchResultsUpdating {

    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Filter (bottomView)
    @IBOutlet weak var bottomView: UIView!

    // MARK: - Initializers
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ArticleTableViewModel!

    // MARK: - RefreshControl
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(ArticleTableViewController.pullToRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        viewModel.fetchAPIData()
    }

    // MARK: - Search Controller
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search the news...".localized
        definesPresentationContext = true
        return searchController
    }()

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.searchTerm = searchText
        }
    }

    // MARK: - ViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView
        tableView.delegate = self
        tableView.dataSource = self

        // Refresh Controller
        tableView.addSubview(self.refreshControl)

        // Search Controller
        navigationItem.searchController = searchController

        // ViewModel
        viewModel.searchTerm = "" // Runs first Search by setting this value

        // BottomView
        bottomViewBottomConstraint.constant = -100

        // Navigation Controller
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        bottomViewHeightConstraint.constant = 44 + self.view.safeAreaInsets.bottom
        self.pullToRefresh(refreshControl)
        super.viewDidAppear(animated)
    }
}

// MARK: - TableViewDataSource
extension ArticleTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleCell = ArticleTableViewCell.dequeuedReusableCell(tableView, indexPath: indexPath)
        articleCell.article = ArticleTableViewModel.getObject(from: viewModel.articles, with: indexPath)
        return articleCell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDelegate:
extension ArticleTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userDidSelect(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Get Article:
        let article = ArticleTableViewModel.getObject(from: viewModel.articles, with: indexPath)
        let initialReadStatus = article.wasRead
        let finalReadStatusText = ArticleState.getText(initialReadStatus: initialReadStatus)

        // Setups Button Text
        let readStatus = UITableViewRowAction(style: .normal, title: finalReadStatusText) { _, indexPath in
            self.viewModel.updateReadStatus(finalReadState: !article.wasRead, article: article)
            let articleCell = ArticleTableViewCell.dequeuedReusableCell(tableView, indexPath: indexPath)
            articleCell.updateWasReadStatus(initialReadStatus)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        readStatus.backgroundColor = Color.mainColor()

        return [readStatus]
    }
}

// MARK: - View Model ArticleTableProtocol
extension ArticleTableViewController: ArticleTableProtocol {

    func updateData(articles: [Article], endRefreshing: Bool) {
        if endRefreshing {
            self.refreshControl.endRefreshing()
        }
        self.tableView.reloadData()
    }

    func displayError(error: Error, endRefreshing: Bool) {
        if endRefreshing {
            self.refreshControl.endRefreshing()
        }
        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 2.0)
    }

    func displayMessage(_ message: String) {
        self.toastr(message)
    }

}

// MARK: - Filter Button and BottomView animation
extension ArticleTableViewController {

    @IBAction func filterButtonClicked(_ sender: UIBarButtonItem) {
        bottomViewBottomConstraint.constant = viewModel.toggledContraintForFilterView(self.bottomView.frame.height)

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 5,
                       options: .curveEaseInOut, animations: {
            self.bottomView.superview?.layoutIfNeeded()
        })
    }

    @IBAction func titleFilterClicked(_ sender: UIButton) {
        viewModel.articlesOrder = .title
    }

    @IBAction func authorsFilterClicked(_ sender: UIButton) {
        viewModel.articlesOrder = .authors
    }

    @IBAction func defaultFilterClicked(_ sender: Any) {
        viewModel.articlesOrder = .id
    }
}
