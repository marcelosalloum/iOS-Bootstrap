//
//  WelcomeViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 11/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class WelcomeViewModel: NSObject {
    // MARK: - Injected Dependencies
    weak var coordinator: WelcomeViewControllerDelegate?

    // MARK: - Properties
    public let objects: [StoryboardName] = [.auth, .table, .collection]
}

// MARK: - User Selected index path
extension WelcomeViewModel: ListViewModelProtocol {
    func userDidSelect(indexPath: IndexPath) {
        let storyboardName = WelcomeViewModel.getObject(from: objects, with: indexPath)
        coordinator?.userDidSelectStoryboard(storyboardName)
    }
}
