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
    static func getArticlesList(_ success: @escaping (([Article]) -> Void), failure: ((Error) -> Void)? = nil) {
        Alamofire.request(APIPaths.articleURL).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonValue = response.result.value {
                    let swiftyJsonVar = JSON(jsonValue)
                    
                    // TODO: send to a separateFile:
                    storeFetched(articles: swiftyJsonVar.array, success: success, failure: failure)
                } else {
                    success([])
                }
            case .failure(let error):
                print(error)
                failure?(error)
            }
        }
    }
    
//    public enum GetOrCreate: String {
//        case get
//        case create
//    }
//
    static func storeFetched(articles: [JSON]?, success: (([Article]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Input validations
        guard let articles = articles else { return }
        if articles.isEmpty { return }

        // Basic CoreData Setup
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        var articlesArray: [Article] = []
        
        // Looping over the articles
        for articleJSON in articles {
            let articleID = String(articleJSON["id"].intValue)
            
            // GET or CREATE
            let (articleOptional, _, error) = Article.getOrCreate(context: context, fetchRequest: fetchRequest, attribute: "id", value: articleID)
            
            // Error handling [GET or CREATE]
            if let error = error {
                failure?(error)
                return
            }
            guard let article = articleOptional else { return }
            // TODO: Ask from Articles class:
            importJSON(from: articleJSON, toObject: article)
            articlesArray.append(article)
        }

        // Context Save
        do {
            try context.save()
            success(articlesArray)
        } catch let error as NSError {
            // Error handling [Context Save]
            print("ERROR: \(error.localizedDescription)")  // TODO: turn on/off verbose option
            failure?(error)
            return
        }
    }
    
    fileprivate static func importJSON(from: JSON, toObject: Article) {
        // else, we create the track like this
        if let id = from["id"].int16 {
            toObject.id = id
        }
        if let authors = from["authors"].string {
            toObject.authors = authors
        }
        if let content = from["content"].string {
            toObject.content = content
        }
        if let dateString = from["date"].string {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            
            if let date = dateFormatter.date(from: dateString) {
                toObject.date = date
            }
        }
        if let imageUrl = from["image_url"].string {
            toObject.imageUrl = imageUrl
        }
        if let title = from["title"].string {
            toObject.title = title
        }
        if let website = from["website"].string {
            toObject.website = website
        }
        // TODO:
//        if let tagsArray = from["tags"].array {
//            for tagDict in tagsArray {
//                // Get Tag ID
//                // Get or Create Tag
//                // Update Tag values
//                // Add tag to Article
//            }
//        }
    }
}
