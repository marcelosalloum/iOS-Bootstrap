//
//  Article+CoreDataClass.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 10/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//
//

import Foundation
import CoreData


public class Article: NSManagedObject {
    func toggleWasRead() {
        self.wasRead = !self.wasRead
    }
}
