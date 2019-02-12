//
//  RestAPI.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import EZCoreData

struct APIPaths {
    static let rootUrl: String = "https://private-0d75e8-cklchallenge.apiary-mock.com"
    static let articleURL: String = "\(APIPaths.rootUrl)/article"
}

struct APIHelper {

    static func getArticlesList(_ context: NSManagedObjectContext,
                                _ completion: @escaping (EZCoreDataResult<[Article]>) -> Void) {
        Alamofire.request(APIPaths.articleURL).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonArray = response.result.value as? [[String: Any]] {
                    Article.importList(jsonArray,
                                       idKey: Constants.idKey,
                                       backgroundContext: context,
                                       completion: completion)
                } else {
                    completion(EZCoreDataResult<[Article]>.success(result: []))
                    print("Method **getArticlesList** got empty results from GET Request to the API")
                }
            case .failure(let error):
                print(error)
                completion(EZCoreDataResult<[Article]>.failure(error: error))
            }
        }
    }
}

// MARK: - Reachability
extension APIHelper: EnableReachabilityProtocol {
    static let reachabilityManager = NetworkReachabilityManager()
}
