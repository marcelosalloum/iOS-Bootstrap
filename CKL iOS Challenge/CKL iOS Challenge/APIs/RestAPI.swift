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

class RestAPI: NSObject {
    static func getArticlesList(_ successCallback: @escaping () -> Void, failureCallback: @escaping (Error) -> Void) {
        Alamofire.request("https://private-0d75e8-cklchallenge.apiary-mock.com/article").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                print("Validation Successful")
                
                if let jsonValue = response.result.value {
                    let swiftyJsonVar = JSON(jsonValue)
                    storeFetched(articles: swiftyJsonVar.array)
                }
                successCallback()
            case .failure(let error):
                print(error)
                failureCallback(error)
            }
        }
        
    }
    
    static func storeFetched(articles: [JSON]?) {
        // Input validations
        guard let articles = articles else { return }
        if articles.isEmpty { return }

        // Basic CoreData Setup
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        let entityDescription = NSEntityDescription.entity(forEntityName: "Article", in: context)
        
        let articlesIDs = articles.compactMap{$0["id"]}
        for articleJSON in articles {
            let articleID = articleJSON["id"].intValue
            let predicate = NSPredicate(format: "%K == %i", "id", articleID)
            fetchRequest.predicate = predicate
            
            // query for object with specified trackId, note that while SoundCloud returns field "id", we save it in "trackId" name
            var fetchedResults: [Article] = []
            
            do {
                fetchedResults = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            // if there are any result, we just skip
            if (fetchedResults.count > 0) {
                continue
            }
            // else, we create the track like this
            let article = Article(context: context)
            if let id = articleJSON["id"].int16 {
                article.id = id
            }
            if let authors = articleJSON["authors"].string {
                article.authors = authors
            }
            if let content = articleJSON["content"].string {
                article.content = content
            }
            if let imageUrl = articleJSON["image_url"].string {
                article.imageUrl = imageUrl
            }
            if let title = articleJSON["title"].string {
                article.title = title
            }
            if let website = articleJSON["website"].string {
                article.website = website
            }
        }
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

        do {
            try context.save()
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
            return
        }
        
        
    }

}
