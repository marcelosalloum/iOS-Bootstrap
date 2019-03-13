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

// MARK: - Result Handling
/// Handles any kind of results
enum APIResult<Value> {
    /// Handles success results
    case success(_ result: Value?)

    /// Handles failure results
    case failure(_ error: CustomError)
}

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

// MARK: - Helper methods
extension APIService {
    /// Handles response JSON, dealing with the common errors
    private static func handleResponseJSON<T, U>(result resultData: Alamofire.Result<Any>,
                                                 inputType: U.Type,
                                                 outputType: T.Type,
                                                 completion: @escaping (APIResult<T>) -> Void,
                                                 _ code: @escaping (U) throws -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            switch resultData {

            case .success(let value):
                if let jsonArray = value as? U {
                    do {
                        try code(jsonArray)
                    } catch let error {
                        self.modelInconsistencyError(error, completion)
                    }
                } else {
                    modelInconsistencyError(nil, completion)
                }

            case .failure(let error):
                Logger.log(error, verboseLevel: .error)
                completion(.failure(CustomError(error: error)))
            }
        }
    }

    /// Regular model inconsistency error
    fileprivate static func modelInconsistencyError<T>(_ error: Error?, _ completion: (APIResult<T>) -> Void) {
        let errorStatus = CustomError(code: .customError, error: error)
        errorStatus.localizedDescription = "Model inconsistency found when parsing data from API."
        Logger.log(errorStatus, verboseLevel: .error)
        completion(.failure(errorStatus))
    }
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
