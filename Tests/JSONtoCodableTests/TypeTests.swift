//
//  TypeTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class TypeTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodable()
    }

    func testOptionalTypes() {
        XCTAssertEqual(Type.string.optional(), Type.optionalString)
        XCTAssertEqual(Type.bool.optional(), Type.optionalBool)
        XCTAssertEqual(Type.int.optional(), Type.optionalInt)
        XCTAssertEqual(Type.double.optional(), Type.optionalDouble)
        XCTAssertEqual(Type.any.optional(), Type.optionalAny)
        XCTAssertEqual(Type.struct("Test").optional(), Type.optionalStruct("Test"))

        XCTAssertEqual(Type.optionalString.optional(), Type.optionalString)
        XCTAssertEqual(Type.optionalBool.optional(), Type.optionalBool)
        XCTAssertEqual(Type.optionalInt.optional(), Type.optionalInt)
        XCTAssertEqual(Type.optionalDouble.optional(), Type.optionalDouble)
        XCTAssertEqual(Type.optionalAny.optional(), Type.optionalAny)
        XCTAssertEqual(Type.optionalStruct("Test").optional(), Type.optionalStruct("Test"))

        XCTAssertEqual(Type.stringArray.optional(), Type.stringOptionalArray)
        XCTAssertEqual(Type.boolArray.optional(), Type.boolOptionalArray)
        XCTAssertEqual(Type.intArray.optional(), Type.intOptionalArray)
        XCTAssertEqual(Type.doubleArray.optional(), Type.doubleOptionalArray)
        XCTAssertEqual(Type.anyArray.optional(), Type.anyOptionalArray)
        XCTAssertEqual(Type.structArray("Test").optional(), Type.structOptionalArray("Test"))

        XCTAssertEqual(Type.stringOptionalArray.optional(), Type.stringOptionalArray)
        XCTAssertEqual(Type.boolOptionalArray.optional(), Type.boolOptionalArray)
        XCTAssertEqual(Type.intOptionalArray.optional(), Type.intOptionalArray)
        XCTAssertEqual(Type.doubleOptionalArray.optional(), Type.doubleOptionalArray)
        XCTAssertEqual(Type.anyOptionalArray.optional(), Type.anyOptionalArray)
        XCTAssertEqual(Type.structOptionalArray("Test").optional(), Type.structOptionalArray("Test"))
    }

    func testRawValueTypes() {
        XCTAssertEqual(Type.string.rawValue, "String")
        XCTAssertEqual(Type.bool.rawValue, "Bool")
        XCTAssertEqual(Type.int.rawValue, "Int")
        XCTAssertEqual(Type.double.rawValue, "Double")
        XCTAssertEqual(Type.any.rawValue, "Any")
        XCTAssertEqual(Type.struct("Test").rawValue, "Test")

        XCTAssertEqual(Type.optionalString.rawValue, "String?")
        XCTAssertEqual(Type.optionalBool.rawValue, "Bool?")
        XCTAssertEqual(Type.optionalInt.rawValue, "Int?")
        XCTAssertEqual(Type.optionalDouble.rawValue, "Double?")
        XCTAssertEqual(Type.optionalAny.rawValue, "Any?")
        XCTAssertEqual(Type.optionalStruct("Test").rawValue, "Test?")

        XCTAssertEqual(Type.stringArray.rawValue, "[String]")
        XCTAssertEqual(Type.boolArray.rawValue, "[Bool]")
        XCTAssertEqual(Type.intArray.rawValue, "[Int]")
        XCTAssertEqual(Type.doubleArray.rawValue, "[Double]")
        XCTAssertEqual(Type.anyArray.rawValue, "[Any]")
        XCTAssertEqual(Type.structArray("Test").rawValue, "[Test]")

        XCTAssertEqual(Type.stringOptionalArray.rawValue, "[String?]")
        XCTAssertEqual(Type.boolOptionalArray.rawValue, "[Bool?]")
        XCTAssertEqual(Type.intOptionalArray.rawValue, "[Int?]")
        XCTAssertEqual(Type.doubleOptionalArray.rawValue, "[Double?]")
        XCTAssertEqual(Type.anyOptionalArray.rawValue, "[Any?]")
        XCTAssertEqual(Type.structOptionalArray("Test").rawValue, "[Test?]")
    }

    func testTypes() {
        let json: String = """
        {
            "string": "String",
            "bool": true,
            "int": 0,
            "double": 1.0,
            "any": any,
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
        let result: String? = try? self.base.generate(json)
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
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testBool() {
        let json: String = """
        {
            "booltrue": true,
            "boolfalse": false
        }
        """
        let expectation: String = """
        struct Result: Codable {
            let booltrue: Bool
            let boolfalse: Bool
        }
        """
        let result: String? = try? self.base.generate(json)
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
        let result: String? = try? self.base.generate(json)
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
        let result: String? = try? self.base.generate(json)
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
        let result: String? = try? self.base.generate(json)
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
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }
}
