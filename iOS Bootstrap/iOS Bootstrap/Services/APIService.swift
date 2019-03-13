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


// MARK: - String Endpoints
/// List of Endpoints
struct APIPath {
    static let rootUrl: String = "https://private-0d75e8-cklchallenge.apiary-mock.com"
    static let articleURL: String = "\(rootUrl)/article"
}

// MARK: - The supported requests
/// Used to manage all API requests in an async way, handling their responses and returning a APIResult<Value> enum
struct APIService {

    static func getArticlesList(_ context: NSManagedObjectContext) -> Promise<[[String: Any]]> {
        return Alamofire.request(APIPath.articleURL).validate().responseJSON()
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

// MARK: - Request Cancellation
extension APIService {
    /// Cancels all Alamofire requests (dataTasks, downloadTasks, uploadTasks)
    static func cancelAllRequests(with url: String? = nil) {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach {
                if self.compare(url: url, on: $0) { $0.cancel() }
            }
            uploadTasks.forEach {
                if self.compare(url: url, on: $0) { $0.cancel() }
            }
            downloadTasks.forEach {
                if self.compare(url: url, on: $0) { $0.cancel() }
            }
        }
    }

    /// Checks if `url` is the one used in the `sessionTask`. If the url is nil, returns true!
    private static func compare(url: String?, on sessionTask: URLSessionTask) -> Bool {
        guard let url = url else { return true }
        guard let taskUrl = sessionTask.originalRequest?.url?.absoluteString else { return false }
        return url == taskUrl
    }
}
