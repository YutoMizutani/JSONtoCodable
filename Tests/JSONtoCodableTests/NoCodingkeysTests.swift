//
//  NoCodingkeysTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class NoCodingkeysTests: XCTestCase {
    var base: JSONtoCodableMock!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodableMock()
    }

    func testNoCodingkeys() {
        let json: String = """
        {
            "hello": "World"
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let hello: String
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }
}
