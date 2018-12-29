//
//  RestAPI.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 28/12/18.
//  Copyright © 2018 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import Alamofire

class RestAPI: NSObject {
    static func getArticlesList(_ successCallback: @escaping () -> Void, failureCallback: @escaping (Error) -> Void) {
        Alamofire.request("https://private-0d75e8-cklchallenge.apiary-mock.com/article").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                print("Validation Successful")
                successCallback()
            case .failure(let error):
                print(error)
                failureCallback(error)
            }
        }
        
    }
}
