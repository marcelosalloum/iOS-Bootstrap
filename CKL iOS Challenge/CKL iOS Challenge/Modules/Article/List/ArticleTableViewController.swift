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

class ArticleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleTableProtocol, UISearchResultsUpdating {
    
    
    // MARK: - Initializers
    @IBOutlet weak var tableView: UITableView!
    let articleTableViewModel = ArticleTableViewModel()
    
    // MARK: - RefreshControl
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ArticleTableViewController.pullToRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        articleTableViewModel.fetchAPIData()
    }
    
    // MARK: - Search Controller
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search the news..."
        definesPresentationContext = true
        return searchController
    }()
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            articleTableViewModel.searchTerm = searchText
        }
    }
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(self.refreshControl)
        navigationItem.searchController = searchController

        articleTableViewModel.delegate = self
        articleTableViewModel.setupInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidAppear(_ animated: Bool) {
        articleTableViewModel.transitionBottomViewToState(bottomView, shouldShow: false, animated: false)
        bottomView.isHidden = false
        super.viewDidAppear(animated)
        self.pullToRefresh(refreshControl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Data validations
        guard let articleDetailViewController = segue.destination as? ArticleDetailViewController else { return }
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        if row >= articleTableViewModel.articles.count { return }
        
        // Article Detail Setup
        articleDetailViewController.articleDetailViewModel.article = articleTableViewModel.articles[row]
    }
    
    // MARK: - TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleTableViewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        
        // Retrieve the correspondant article
        if indexPath.row >= articleTableViewModel.articles.count { return articleCell }
        let article = articleTableViewModel.articles[indexPath.row]

        // Set-up the cell content
        articleCell.titleLabel.text = article.title
        articleCell.timeLabel.text = NSDate.timeAgoSince(article.date, shortPattern: true)
        articleCell.authorLabel.text = article.authors
        articleCell.updateWasReadStatus(article.wasRead)
        
        // Setup the cell image
        guard let articleImageView = articleCell.articleImageView else { return articleCell }
        guard let imageURL = article.imageUrl else { return articleCell }
        guard let url = URL(string: imageURL) else { return articleCell }
        // Image Caching
        articleImageView.kf.indicatorType = .activity
        articleImageView.kf.setImage(with: url)
     
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
        let article = articleTableViewModel.articles[indexPath.row]
        let initialReadStatus = article.wasRead
        let finalReadStatusText = ArticleState.getText(initialReadStatus: initialReadStatus)
        
        // Setups Button Text
        let readStatus = UITableViewRowAction(style: .normal, title: finalReadStatusText) { tableViewRowAction, indexPath in
            self.articleTableViewModel.updateReadStatus(finalReadState: !article.wasRead, article: article) {
                let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
                articleCell.updateWasReadStatus(initialReadStatus)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        readStatus.backgroundColor = .blue
        
        return [readStatus]
    }

    // MARK: - ArticleTableProtocol
    
    func updateData(articles: [Article], endRefreshing: Bool) {
        if endRefreshing {
            refreshControl.endRefreshing()
        }
        self.tableView.reloadData()
    }
    
    func displayError(error: Error, endRefreshing: Bool) {
        if endRefreshing {
            refreshControl.endRefreshing()
        }
        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 2.0)
    }
    
    // MARK: - Filter
    @IBOutlet weak var bottomView: UIView!
    
    @IBAction func filterButtonClicked(_ sender: UIBarButtonItem) {
        articleTableViewModel.filterButtonClicked(bottomView)
    }
    
    @IBAction func titleFilterClicked(_ sender: UIButton) {
        articleTableViewModel.articlesOrder = .title
    }
    
    @IBAction func authorsFilterClicked(_ sender: UIButton) {
        articleTableViewModel.articlesOrder = .authors
    }
    
    @IBAction func defaultFilterClicked(_ sender: Any) {
        articleTableViewModel.articlesOrder = .id
    }
}
