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

class ArticleTableViewController: UITableViewController, ArticleTableDelegate {
    
    // Mark - Article Table Delegate
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
    
    
    let articleTableViewModel = ArticleTableViewModel()
    
    // MARK - Pull to refresh action
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        articleTableViewModel.fetchAPIData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableViewModel.delegate = self
        refreshControl?.programaticallyBeginRefreshing(in: tableView)
        articleTableViewModel.setupInitialData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let refreshControl = self.refreshControl else { return }
        self.pullToRefresh(refreshControl)
    }
    
    // MARK: - Table view data source

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
        articleCell.titleLabel?.text = article.title
        articleCell.tagsLabel?.text = article.authors
        
        // Setup the cell image
        guard let articleImageView = articleCell.articleImageView else { return articleCell }
        guard let imageURL = article.imageUrl else { return articleCell }
        guard let url = URL(string: imageURL) else { return articleCell }
        // Image Caching
        articleImageView.kf.indicatorType = .activity
        articleImageView.kf.setImage(with: url)
     
        return articleCell
    }

    // MARK - Action - Did Select Row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "articleDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Data validations
        guard let articleDetailViewController = segue.destination as? ArticleDetailViewController else { return }
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        if row >= articleTableViewModel.articles.count { return }
        
        // Article Detail Setup
        articleDetailViewController.article = articleTableViewModel.articles[row]
    }
}
