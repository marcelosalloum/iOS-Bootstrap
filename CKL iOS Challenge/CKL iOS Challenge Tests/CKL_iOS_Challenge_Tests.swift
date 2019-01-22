//
//  CKL_iOS_Challenge_Tests.swift
//  CKL iOS Challenge Tests
//
//  Created by Marcelo Salloum dos Santos on 21/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import XCTest

class CKL_iOS_Challenge_Tests: XCTestCase {

    func testHelloWorld() {
        var helloWorld: String?
        
        XCTAssertNil(helloWorld)
        
        helloWorld = "Hello World"
        XCTAssertEqual(helloWorld, "Hello World")
    }

}
