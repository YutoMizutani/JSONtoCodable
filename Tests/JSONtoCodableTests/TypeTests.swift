//
//  TypeTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class TypeTests: XCTestCase {
    var base: JSONtoCodableMock!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodableMock()
    }

    func testTypes() {
        let json: String = """
        {
            "string": "String"
            "bool": true
            "int": 0
            "double": 1.0
            "any": any
            "optionalany": nil
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let string: String
            let bool: Bool
            let int: Int
            let double: Double
            let any: Any
            let optionalany: Any?
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testString() {
        let json: String = """
        {
            "string": "String"
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let string: String
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testBool() {
        let json: String = """
        {
            "booltrue": true
            "boolfalse": false
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let booltrue: Bool
            let boolfalse: Bool
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testInt() {
        let json: String = """
        {
            "int": 0
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let int: Int
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testDouble() {
        let json: String = """
        {
            "double": 1.0
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let double: Double
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testAny() {
        let json: String = """
        {
            "any": any
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let any: Any
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }

    func testOptionalAny() {
        let json: String = """
        {
            "optionalany": nil
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let optionalany: Any?
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, expectation)
    }
}
