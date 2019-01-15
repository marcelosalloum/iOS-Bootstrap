//
//  RestAPI.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData


struct APIPaths {
    static let rootUrl: String = "https://private-0d75e8-cklchallenge.apiary-mock.com"
    static let articleURL: String = "\(APIPaths.rootUrl)/article"
}

enum Completion<Object> {
    case success(objects: [Object])
    case failure(error: Error)
}


class RestAPI: NSObject {
    
    static func getArticlesList(_ success: @escaping (([Article]) -> Void), failure: ((Error) -> Void)? = nil) {
        Alamofire.request(APIPaths.articleURL).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonValue = response.result.value {
                    let swiftyJSONVar = JSON(jsonValue)
                    
                    // TODO: send to a separateFile:
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    Article.asyncImportObjects(swiftyJSONVar.array, context: context, success: success, failure: failure, idKey: "id")
                } else {
                    success([])
                }
            case .failure(let error):
                print(error)
                failure?(error)
            }
        }
    }
    
    static func getArticlesList(_ completion: @escaping (Completion<Article>) -> Void) {
        Alamofire.request(APIPaths.articleURL).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonValue = response.result.value {
                    let swiftyJSONVar = JSON(jsonValue)
                    
                    // TODO: send to a separateFile:
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    Article.asyncImportObjects(swiftyJSONVar.array, context: context, success: { articles in
                        completion(Completion<Article>.success(objects: articles))
                    }, failure: { error in
                        completion(Completion<Article>.failure(error: error))
                    }, idKey: "id")
                } else {
                    completion(Completion<Article>.success(objects: []))
                }
            case .failure(let error):
                print(error)
                completion(Completion<Article>.failure(error: error))
            }
        }
    }
}
