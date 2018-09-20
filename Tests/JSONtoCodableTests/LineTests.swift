//
//  LineTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class LineTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.base = JSONtoCodable()
    }

    func testDefault() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let structString: String = """
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
        XCTAssertEqual(result, structString)
    }

    func testLF() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let structString: String = """
        struct Result: Codable {\n    let hello: String\n    let helloWorld: String\n\n    private enum CodingKeys: String, CodingKey {\n        case hello = "Hello"\n        case helloWorld = "HelloWorld"\n    }\n}
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testCR() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let structString: String = """
        struct Result: Codable {\r    let hello: String\r    let helloWorld: String\r\r    private enum CodingKeys: String, CodingKey {\r        case hello = "Hello"\r        case helloWorld = "HelloWorld"\r    }\r}
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testCRLF() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let structString: String = """
        struct Result: Codable {\r\n    let hello: String\r\n    let helloWorld: String\r\n\r\n    private enum CodingKeys: String, CodingKey {\r\n        case hello = "Hello"\r\n        case helloWorld = "HelloWorld"\r\n    }\r\n}
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }
}
