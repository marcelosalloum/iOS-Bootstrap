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

class ArticleTableViewController: UITableViewController, ArticleTableProtocol, UISearchResultsUpdating {
    
    
    // MARK: - Initializers
    let articleTableViewModel = ArticleTableViewModel()
    var searchController: UISearchController!
    
    // MARK: - Search Controller
    func initializeSearchController() {
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            articleTableViewModel.filterArticles(searchText)
            tableView.reloadData()
        }
    }
    
    // MARK: - ViewController
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        articleTableViewModel.fetchAPIData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableViewModel.delegate = self
        refreshControl?.programaticallyBeginRefreshing(in: tableView)
        articleTableViewModel.setupInitialData()
        initializeSearchController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let refreshControl = self.refreshControl else { return }
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleTableViewModel.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "articleDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
            refreshControl?.endRefreshing()
        }
        self.tableView.reloadData()
    }
    
    func displayError(error: Error, endRefreshing: Bool) {
        if endRefreshing {
            refreshControl?.endRefreshing()
        }
        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 2.0)
    }
}
