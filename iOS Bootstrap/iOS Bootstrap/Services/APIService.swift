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
    static let articleURL: String = "\(APIPaths.rootUrl)/article"
}

struct APIService {

    static func getArticlesList(_ context: NSManagedObjectContext) -> Promise<[Article]?> {
//        Alamofire.request(APIPaths.articleURL).validate().responseJSON { (response) in
//            switch response.result {
//            case .success:
//                if let jsonArray = response.result.value as? [[String: Any]] {
//                    Article.importList(jsonArray,
//                                       idKey: Constants.idKey,
//                                       backgroundContext: context,
//                                       completion: completion)
//                } else {
//                    completion(EZCoreDataResult<[Article]>.success(result: []))
//                    print("Method **getArticlesList** got empty results from GET Request to the API")
//                }
//            case .failure(let error):
//                print(error)
//                completion(EZCoreDataResult<[Article]>.failure(error: error))
//            }
//        }
        return promisedGetArticlesList(url: APIPaths.articleURL).then { json -> Promise<[Article]?> in
            promisedImportArticlesList(jsonArray: json, idKey: Constants.idKey, bckgContext: context)
            }.then({ importedArticles -> Promise<[Article]?> in
                promisedDeleteAllArticles(except: importedArticles, idKey: Constants.idKey, bckgContext: context)
            })
    }

    static func promisedGetArticlesList(url: String) -> Promise<[[String: Any]]> {
        return Promise<[[String: Any]]>.init { resolver in
            Alamofire.request(url).validate().responseJSON { response in
                switch response.result {
                case .success(let resultValue):
                    guard let result = resultValue as? [[String: Any]] else { return }
                    print(result)
                    resolver.fulfill(result)
                case .failure(let error):
                    print(error)
                    resolver.reject(error)
                }
            }
        }
    }

    static func promisedImportArticlesList(jsonArray: [[String: Any]],
                                           idKey: String,
                                           bckgContext: NSManagedObjectContext) -> Promise<[Article]?> {
        return Promise<[Article]?>.init { resolver in
            Article.importList(jsonArray,
                               idKey: Constants.idKey,
                               backgroundContext: bckgContext) { result in
                switch result {
                case .success(let result):
                    print(result ?? "")
                    resolver.fulfill(result)
                case .failure(let error):
                    resolver.reject(error)
                    print(error)
                }

            }
        }
    }

//    fileprivate func extractedFunc<T>(_ result: EZCoreDataResult<T>, resolver: Resolver<T?>) {
//        switch result {
//        case .success(let value):
//            resolver.fulfill(value)
//        case .failure(let error):
//            resolver.reject(error)
//            print(error)
//        }
//    }

    static func promisedDeleteAllArticles(except articleList: [Article]?,
                                          idKey: String,
                                          bckgContext: NSManagedObjectContext) -> Promise<[Article]?> {
        return Promise<[Article]?>.init { resolver in
            Article.deleteAll(except: articleList,
                              backgroundContext: bckgContext) { result in
                switch result {
                case .success:
                    resolver.fulfill(articleList)
                case .failure(let error):
                    resolver.reject(error)
                    print(error)
                }

            }
        }
    }
}

// MARK: - Reachability
extension APIService: EnableReachabilityProtocol {
    static let reachabilityManager = NetworkReachabilityManager()
}
