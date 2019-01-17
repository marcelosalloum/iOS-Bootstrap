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

class RestAPI: NSObject {
    
    static func getArticlesList(_ completion: @escaping (AwesomeDataResult<[Article]>) -> Void) {
        Alamofire.request(APIPaths.articleURL).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonValue = response.result.value {
                    let swiftyJSONVar = JSON(jsonValue)
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    Article.asyncImportObjects(swiftyJSONVar.array, context: context, completion: completion, idKey: "id")
                } else {
                    completion(AwesomeDataResult<[Article]>.success(objectList: []))
                    print("Method **getArticlesList** got empty results from GET Request to the API")
                }
            case .failure(let error):
                print(error)
                completion(AwesomeDataResult<[Article]>.failure(error: error))
            }
        }
    }
}
