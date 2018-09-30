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
        let expectation: String = """
        public struct Result: Codable {
            public let hello: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
            }
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(expectation, result)
    }

    func testNoLines() {
        let json: String = """
        {"Hello": "World"}
        """
        let expectation: String = """
        public struct Result: Codable {
            public let hello: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
            }
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testBeginSingleSpaceAndNoBracket() {
        let json: String = " \"Hello\": \"World\""
        let expectation: String = """
        public struct Result: Codable {
            public let hello: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
            }
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testBeginSingleSpaceAndNoLines() {
        let json: String = " {\"Hello\": \"World\"}"
        let expectation: String = """
        public struct Result: Codable {
            public let hello: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
            }
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }
}
