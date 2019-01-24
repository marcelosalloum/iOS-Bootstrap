//
//  ArticleTableViewController.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher
import SwiftMessages


class ArticleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleTableProtocol, UISearchResultsUpdating {
    
    @IBOutlet weak var bottomViewConstraintBottom: NSLayoutConstraint!
    
    // MARK: - Initializers
    @IBOutlet weak var tableView: UITableView!
    let viewModel = ArticleTableViewModel()
    
    // MARK: - RefreshControl
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ArticleTableViewController.pullToRefresh(_:)), for: UIControl.Event.valueChanged)
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
        viewModel.delegate = self
        viewModel.searchTerm = ""  // Runs first Search by setting this value
        viewModel.transitionBottomView(bottomView, shouldShow: false, layoutConstraint: bottomViewConstraintBottom, animated: false)

        // Navigation Controller
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Offline Handling
        type(of: self).setupReachability()
        
        NotificationCenter.default.addObserver(viewModel, selector: #selector(ArticleTableViewModel.phoneIsOnline(notification:)), name: AppNotifications.PhoneIsOnline, object: nil)
        NotificationCenter.default.addObserver(viewModel, selector: #selector(ArticleTableViewModel.phoneIsOffline(notification:)), name: AppNotifications.PhoneIsOffline, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(viewModel, name: AppNotifications.PhoneIsOnline, object: nil)
        NotificationCenter.default.removeObserver(viewModel, name: AppNotifications.PhoneIsOffline, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pullToRefresh(refreshControl)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Data validations
        guard let articleDetailViewController = segue.destination as? ArticleDetailViewController else { return }
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        if row >= viewModel.articles.count { return }
        
        // Article Detail Setup
        articleDetailViewController.viewModel.article = viewModel.articles[row]
    }
    
    // MARK: - TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        
        // Retrieve the correspondant article and set-up the cell
        if indexPath.row >= viewModel.articles.count { return articleCell }
        let article = viewModel.articles[indexPath.row]
        articleCell.article = article
     
        return articleCell
    }
    
    // MARK: - TableViewDelegate:
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "articleDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Get Article:
        let article = viewModel.articles[indexPath.row]
        let initialReadStatus = article.wasRead
        let finalReadStatusText = ArticleState.getText(initialReadStatus: initialReadStatus)
        
        // Setups Button Text
        let readStatus = UITableViewRowAction(style: .normal, title: finalReadStatusText) { tableViewRowAction, indexPath in
            self.viewModel.updateReadStatus(finalReadState: !article.wasRead, article: article) { completion in
                if case .failure(_) = completion { return }
                let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
                articleCell.updateWasReadStatus(initialReadStatus)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        readStatus.backgroundColor = Color.mainColor()
        
        return [readStatus]
    }

    // MARK: - ArticleTableProtocol
    
    func updateData(articles: [Article], endRefreshing: Bool) {
        DispatchQueue.main.async {
            if endRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView.reloadData()
        }
    }
    
    func displayError(error: Error, endRefreshing: Bool) {
        DispatchQueue.main.async {
            if endRefreshing {
                self.refreshControl.endRefreshing()
            }
            HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 2.0)
        }
    }
    
    // MARK: - Filter
    @IBOutlet weak var bottomView: UIView!
    
    @IBAction func filterButtonClicked(_ sender: UIBarButtonItem) {
        viewModel.filterButtonClicked(self.view, layoutConstraint: bottomViewConstraintBottom)
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
