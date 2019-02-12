//
//  ViewModelProtocol.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

protocol ListViewModelProtocol {
    static func getObject<T: Any>(from objectsList: [T], with indexPath: IndexPath) -> T
    func userDidSelect(indexPath: IndexPath)
}

extension ListViewModelProtocol {
    ///  Returns an object from a given array that corresponds to the indexPath
    static func getObject<T: Any>(from objectsList: [T], with indexPath: IndexPath) -> T {
        // Retrieve the correspondant article and set-up the cell
        if indexPath.row >= objectsList.count {
            fatalError("EMPTY_OBJECT_LIST".localized)
        }
        let article = objectsList[indexPath.row]
        return article
    }
}

protocol CollectionViewModelProtocol {
    static func getObject<T: Any>(from objectsList: [T], with indexPath: IndexPath) -> T
    func userDidSelect(indexPath: IndexPath)
}

extension CollectionViewModelProtocol {
    ///  Returns an object from a given array type [T] according to the indexPath
    static func getCollectionSectionData<T: Any>(from objectsList: [[T]], with indexPath: IndexPath) -> [T] {
        // Retrieve the correspondant article and set-up the cell
        if indexPath.section >= objectsList.count {
            fatalError("EMPTY_OBJECT_LIST".localized)
        }
        let articleList = objectsList[indexPath.section]
        return articleList
    }
}
