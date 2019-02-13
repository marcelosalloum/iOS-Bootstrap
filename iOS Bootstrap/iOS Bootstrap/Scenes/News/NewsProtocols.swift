//
//  NewsProtocols.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 12/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

// MARK: - Protocol to comunicate from ViewModel o Coordinator (MVVM-C)
/// Protocol to comunicate from ViewModel o Coordinator (MVVM-C)
protocol NewsInteractionProtocol: class {
    func userDidSelectArticle(_ selectedArticle: Article)
}

// MARK: - Protocol to comunicate from ViewModel o ViewController (MVVM-C)
/// Protocol to comunicate from ViewModel o ViewController (MVVM-C)
protocol NewsCollectionViewDelegate: class {
    func reloadData(endRefreshing: Bool)
    func displayError(error: Error, endRefreshing: Bool)
    func displayMessage(_ message: String)
}
