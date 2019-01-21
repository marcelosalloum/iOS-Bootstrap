//
//  RestAPI.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import Alamofire
import CoreData


struct APIPaths {
    static let rootUrl: String = "https://private-0d75e8-cklchallenge.apiary-mock.com"
    static let articleURL: String = "\(APIPaths.rootUrl)/article"
}

class RestAPI: NSObject {
    
    static func getArticlesList(_ completion: @escaping (EZCoreDataResult<[Article]>) -> Void) {
        Alamofire.request(APIPaths.articleURL).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonArray = response.result.value as? [[String: Any]] {
                    Article.asyncImportObjects(jsonArray, backgroundContext: EZCoreData.shared.privateThreadContext, completion: completion, idKey: "id")
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
