//
//  ArticleTableViewController.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import PKHUD
import Nuke

class ArticleTableViewController: UITableViewController {
    
    // MARK - Pull to Refresh action
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        fetchAPIData {
            sender.endRefreshing()
        }
    }
    
    // MARK - Reload Data Action
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        
        let article = articles[indexPath.row]

        articleCell.titleLabel?.text = article.title
        articleCell.tagsLabel?.text = article.authors
        guard let imageView = articleCell.imageView else { return articleCell }
        
        guard let imageURL = article.imageUrl else { return articleCell }
        guard let url = URL(string: imageURL) else { return articleCell }
        
        // Nuke
        Nuke.loadImage(with: url, into: imageView)
     
        return articleCell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section: \(section)"
    }
}
