//
//  JSONtoCodableTests.swift
//  JSONtoCodableTests
//
//  Created by Yuto Mizutani on 2018/09/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest
@testable import JSONtoCodable

class JSONtoCodableTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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

    func testPascalCase() {
        let json: String = """
        {
            "Hello": "World"
        }
        """
        let structString: String = """
        struct Result: Codable {
            let hello: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
            }
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testNoBracket() {
        let json: String = """
        "Hello": "World"
        """
        let structString: String = """
        struct Result: Codable {
            let hello: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
            }
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(structString, result)
    }

    func testNoLines() {
        let json: String = """
        {"Hello": "World"}
        """
        let structString: String = """
        struct Result: Codable {
            let hello: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
            }
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }
}
