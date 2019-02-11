//
//  WelcomeViewModel.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 11/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class WelcomeViewModel: NSObject {
    weak var coordinator: WelcomeViewControllerDelegate?

    public let objects: [StoryboardName] = [.auth, .news, .collection]

    func userDidSelect(indexPath: IndexPath) {
        let storyboardName = WelcomeViewModel.getObject(from: objects, with: indexPath)
        coordinator?.userDidSelectStoryboard(storyboardName)
    }
}

extension WelcomeViewModel: ListViewModelProtocol {

}
