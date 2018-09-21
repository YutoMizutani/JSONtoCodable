//
//  IndentTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class IndentTests: XCTestCase {
    var base: JSONtoCodableMock!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodableMock()
    }

    func testDefault() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let hello: String
            let helloWorld: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
                case helloWorld = "HelloWorld"
            }
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testZeroSpace() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {
        let hello: String
        let helloWorld: String

        private enum CodingKeys: String, CodingKey {
        case hello = "Hello"
        case helloWorld = "HelloWorld"
        }
        }
        """
        self.base.config.indentType = .space(0)
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testTwoSpace() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {
          let hello: String
          let helloWorld: String

          private enum CodingKeys: String, CodingKey {
            case hello = "Hello"
            case helloWorld = "HelloWorld"
          }
        }
        """
        self.base.config.indentType = .space(2)
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testFourSpace() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let hello: String
            let helloWorld: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
                case helloWorld = "HelloWorld"
            }
        }
        """
        self.base.config.indentType = .space(4)
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testEightSpace() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {
                let hello: String
                let helloWorld: String

                private enum CodingKeys: String, CodingKey {
                        case hello = "Hello"
                        case helloWorld = "HelloWorld"
                }
        }
        """
        self.base.config.indentType = .space(8)
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testZeroTab() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {
        let hello: String
        let helloWorld: String

        private enum CodingKeys: String, CodingKey {
        case hello = "Hello"
        case helloWorld = "HelloWorld"
        }
        }
        """
        self.base.config.indentType = .tab(0)
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testOneTab() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {
        \tlet hello: String
        \tlet helloWorld: String

        \tprivate enum CodingKeys: String, CodingKey {
        \t\tcase hello = "Hello"
        \t\tcase helloWorld = "HelloWorld"
        \t}
        }
        """
        self.base.config.indentType = .tab(1)
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testTwoTab() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {
        \t\tlet hello: String
        \t\tlet helloWorld: String

        \t\tprivate enum CodingKeys: String, CodingKey {
        \t\t\t\tcase hello = "Hello"
        \t\t\t\tcase helloWorld = "HelloWorld"
        \t\t}
        }
        """
        self.base.config.indentType = .tab(2)
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }
}
