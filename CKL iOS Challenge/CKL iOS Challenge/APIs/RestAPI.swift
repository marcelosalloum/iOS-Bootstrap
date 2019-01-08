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
    static func getArticlesList(_ success: @escaping (([Article]) -> Void), failure: ((Error) -> Void)? = nil) {
        Alamofire.request("https://private-0d75e8-cklchallenge.apiary-mock.com/article").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                print("Validation Successful")
                
                if let jsonValue = response.result.value {
                    let swiftyJsonVar = JSON(jsonValue)
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
    
    public enum GetOrCreate: String {
        case get
        case create
    }
    
    static func fetchAllArticles(success: (([Article]) -> Void), failure: ((Error) -> Void)? = nil) {
        // Basic CoreData Setup
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        var fetchedResults: [Article] = []
        
        // Seting up core data predicate
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // Fetch All
        do {
            fetchedResults = try context.fetch(fetchRequest)
            success(fetchedResults)
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")  // TODO: turn on/off verbose option
            failure?(error)
        }
    }
    
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
            let articleID = articleJSON["id"].intValue
            
            // GET or CREATE
            let (articleOptional, _, error) = getOrCreate(context: context, fetchRequest: fetchRequest, articleID: articleID)
            
            // Error handling [GET or CREATE]
            if let error = error {
                failure?(error)
                return
            }
            guard let article = articleOptional else { return }
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
    
    fileprivate static func getOrCreate(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Article>, articleID: Int) -> (Article?, GetOrCreate?, Error?) {
        // Initializing return variables
        var article: Article!
        var getOrCreate: GetOrCreate!
        var fetchedResults: [Article] = []
        
        // Seting up core data predicate
        let predicate = NSPredicate(format: "%K == %i", "id", articleID)
        fetchRequest.predicate = predicate
        
        // GET
        do {
            fetchedResults = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")  // TODO: turn on/off verbose option
            return (nil, nil, error)
        }
        
        // If GET is empty, then CREATE
        if (fetchedResults.count > 0) {
            article = fetchedResults[0]
            getOrCreate = .get
        } else {
            article = Article(context: context)
            getOrCreate = .create
        }
        
        return (article, getOrCreate, nil)
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
        if let imageUrl = from["image_url"].string {
            toObject.imageUrl = imageUrl
        }
        if let title = from["title"].string {
            toObject.title = title
        }
        if let website = from["website"].string {
            toObject.website = website
        }
    }
}
