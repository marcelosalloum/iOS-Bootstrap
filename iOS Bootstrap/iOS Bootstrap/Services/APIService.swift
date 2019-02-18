//
//  APIService.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import EZCoreData
import PromiseKit

struct APIPaths {
    static let rootUrl: String = "https://private-0d75e8-cklchallenge.apiary-mock.com"
    static let articleURL: String = "\(rootUrl)/article"
}

struct APIService {

    static func getArticlesList(_ context: NSManagedObjectContext) -> Promise<[[String: Any]]> {
        return Alamofire.request(APIPaths.articleURL).validate().responseJSON()
            .map { (json, _) -> [[String: Any]] in

                guard let jsonDict = json as? [[String: Any]] else {
                    throw DefaultError.unknownError
                }

                return jsonDict
        }
    }
}

// MARK: - Reachability
extension APIService: EnableReachabilityProtocol {
    static let reachabilityManager = NetworkReachabilityManager()
}
