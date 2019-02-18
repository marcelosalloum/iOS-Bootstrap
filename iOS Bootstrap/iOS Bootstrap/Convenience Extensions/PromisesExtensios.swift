//
//  PromisesExtensios.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 18/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import CoreData
import EZCoreData
import PromiseKit

extension NSFetchRequestResult where Self: NSManagedObject {
    static public func deleteAll(except toKeep: [Self]? = nil, backgroundContext: NSManagedObjectContext =
        EZCoreData.privateThreadContext) -> Promise<[Self]?> {
        return Promise<[Self]?> { resolver in
            deleteAll(except: toKeep, backgroundContext: backgroundContext) { result in
                switch result {
                case .success:
                    resolver.fulfill(toKeep)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }

    public static func importList(_ jsonArray: [[String: Any]]?,
                                  idKey: String = "id",
                                  backgroundContext: NSManagedObjectContext = EZCoreData.privateThreadContext)
        -> Promise<[Self]?> {
            return Promise<[Self]?> { resolver in
                importList(jsonArray,
                           idKey: idKey,
                           backgroundContext: backgroundContext) { result in
                    switch result {
                    case .success(let result):
                        resolver.fulfill(result)
                    case .failure(let error):
                        resolver.reject(error)
                    }
                }
            }
    }
}
