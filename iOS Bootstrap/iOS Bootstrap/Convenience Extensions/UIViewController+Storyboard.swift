//
//  UIViewController+Storyboard.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

extension ReusableObject where Self: UIViewController {
    static func fromStoryboard(_ storyboardName: String) -> Self? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let viewControllerID = self.reuseIdentifier
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        guard let newViewController = viewController as? Self else { return nil }
        return newViewController
    }
}
