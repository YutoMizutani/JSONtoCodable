//
//  LineTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class LineTests: XCTestCase {
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

    func testLF() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {\n    let hello: String\n    let helloWorld: String\n\n    private enum CodingKeys: String, CodingKey {\n        case hello = "Hello"\n        case helloWorld = "HelloWorld"\n    }\n}
        """
        self.base.config.lineType = .lineFeed
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testCR() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {\r    let hello: String\r    let helloWorld: String\r\r    private enum CodingKeys: String, CodingKey {\r        case hello = "Hello"\r        case helloWorld = "HelloWorld"\r    }\r}
        """
        self.base.config.lineType = .carriageReturn
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testCRLF() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let expectation: String = """
        struct Result: Codable {\r\n    let hello: String\r\n    let helloWorld: String\r\n\r\n    private enum CodingKeys: String, CodingKey {\r\n        case hello = "Hello"\r\n        case helloWorld = "HelloWorld"\r\n    }\r\n}
        """
        self.base.config.lineType = .both
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }
}
