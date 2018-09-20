//
//  TypeTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import Foundation

import XCTest
@testable import JSONtoCodable

class TypeTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.base = JSONtoCodable()
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
        let structString: String = """
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
        XCTAssertEqual(result, structString)
    }

    func testString() {
        let json: String = """
        {
            "string": "String"
        }
        """
        let structString: String = """
        struct Result: Codable {
            let string: String
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testBool() {
        let json: String = """
        {
            "booltrue": true
            "boolfalse": false
        }
        """
        let structString: String = """
        struct Result: Codable {
            let booltrue: Bool
            let boolfalse: Bool
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testInt() {
        let json: String = """
        {
            "int": 0
        }
        """
        let structString: String = """
        struct Result: Codable {
            let int: Int
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testDouble() {
        let json: String = """
        {
            "double": 1.0
        }
        """
        let structString: String = """
        struct Result: Codable {
            let double: Double
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testAny() {
        let json: String = """
        {
            "any": any
        }
        """
        let structString: String = """
        struct Result: Codable {
            let any: Any
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }

    func testOptionalAny() {
        let json: String = """
        {
            "optionalany": nil
        }
        """
        let structString: String = """
        struct Result: Codable {
            let optionalany: Any?
        }
        """
        let result: String? = try? self.base.translate(json)
        XCTAssertEqual(result, structString)
    }
}
