//
//  NoCodingkeysTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class NoCodingkeysTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodable()
    }

    func testNoCodingkeys() {
        let json: String = """
        {
            "hello": "World"
        }
        """
        let structString: String = """
        struct Result: Codable {
            let hello: String
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }
}
