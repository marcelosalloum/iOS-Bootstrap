//
//  UITableView+Getter.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

protocol ReusableObject { }

extension ReusableObject {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableObject { }

extension UIViewController: ReusableObject { }

extension ReusableObject where Self: UITableViewCell {
    static func dequeuedReusableCell(_ tableView: UITableView, indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! Self
    }
}
