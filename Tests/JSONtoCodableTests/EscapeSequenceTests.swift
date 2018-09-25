//
//  EscapeSequenceTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/25.
//

import XCTest
@testable import JSONtoCodable

class EscapeSequenceTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodable()
    }

    func testEscapeSequence() {
        let json: String = """
        {
            "hello": "Hello, \"world!!\""
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let hello: String
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testDoubleEscapeSequence() {
        let json: String = """
        {
            "hello": "Hello, \"world!!\""
            "hello2nd": "Hello, \"world!!\""
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let hello: String
            let hello2nd: String
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }
}
