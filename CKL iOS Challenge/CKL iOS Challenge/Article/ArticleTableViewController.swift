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

class ArticleTableViewController: UITableViewController {
    
    // MARK - Pull to refresh action
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        fetchAPIData {
            sender.endRefreshing()
        }
    }
    
    // MARK - Load data
    func fetchAPIData(_ completion: (() -> ())? = nil) {
        RestAPI.getArticlesList({ (fetchedArticles) in
            self.articles = fetchedArticles
            self.tableView.reloadData()
            completion?()
        }) { (error) in
            HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 2.0)
            completion?()
        }
    }
    
    func setupInitialData() {
        RestAPI.fetchAllArticles(success: {(fetchedArticles) in
            articles = fetchedArticles
            self.tableView.reloadData()
        })
    }
    
    var articles: [Article] = []
    
    // MARK - ViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl?.programaticallyBeginRefreshing(in: tableView)
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
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        
        // Retrieve the correspondant article
        if indexPath.row >= articles.count { return articleCell }
        let article = articles[indexPath.row]

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
        if row >= articles.count { return }
        
        // Article Detail Setup
        articleDetailViewController.article = articles[row]
    }
}
