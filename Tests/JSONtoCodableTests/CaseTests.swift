//
//  CaseTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class CaseTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.base = JSONtoCodable()
    }

    func testPascalCase() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let structString: String = """
        struct Result: Codable {
            let Hello: String
            let HelloWorld: String
        }
        """
        self.base.config.caseType.variable = .pascal
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }
    
    func testCamelCase() {
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
        self.base.config.caseType.variable = .camel
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testSnakeCase() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let structString: String = """
        struct Result: Codable {
            let hello: String
            let hello_world: String

            private enum CodingKeys: String, CodingKey {
                case hello = "Hello"
                case hello_world = "HelloWorld"
            }
        }
        """
        self.base.config.caseType.variable = .snake
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testScreamingSnakeCase() {
        let json: String = """
        {
            "Hello": "Hello, world!!"
            "HelloWorld": "Hello, world!!"
        }
        """
        let structString: String = """
        struct Result: Codable {
            let HELLO: String
            let HELLO_WORLD: String

            private enum CodingKeys: String, CodingKey {
                case HELLO = "Hello"
                case HELLO_WORLD = "HelloWorld"
            }
        }
        """
        self.base.config.caseType.variable = .screamingSnake
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }
}
