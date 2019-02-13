//
//  WelcomeViewController.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 11/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class WelcomeViewController: CoordinatedViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: WelcomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Inits Table View
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension WelcomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storyboardRouteCell = WelcomeTableViewCell.dequeuedReusableCell(tableView, indexPath: indexPath)
        let storyboardName = WelcomeViewModel.getObject(from: viewModel.objects, with: indexPath)
        storyboardRouteCell.textLabel?.text = storyboardName.rawValue
        return storyboardRouteCell
    }
}

extension WelcomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userDidSelect(indexPath: indexPath)
    }
}
