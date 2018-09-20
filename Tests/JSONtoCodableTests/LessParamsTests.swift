//
//  LessParamsTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class NoBracketTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodable()
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
