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

    func testTypesOrder() {
        XCTAssertEqual(Type.string.order, 0)
        XCTAssertEqual(Type.bool.order, 1)
        XCTAssertEqual(Type.int.order, 2)
        XCTAssertEqual(Type.double.order, 3)
        XCTAssertEqual(Type.any.order, 4)
        XCTAssertEqual(Type.struct("Test").order, 5)

        XCTAssertEqual(Type.stringArray.order, 6)
        XCTAssertEqual(Type.boolArray.order, 7)
        XCTAssertEqual(Type.intArray.order, 8)
        XCTAssertEqual(Type.doubleArray.order, 9)
        XCTAssertEqual(Type.anyArray.order, 10)
        XCTAssertEqual(Type.structArray("Test").order, 11)

        XCTAssertEqual(Type.optionalString.order, 12)
        XCTAssertEqual(Type.optionalBool.order, 13)
        XCTAssertEqual(Type.optionalInt.order, 14)
        XCTAssertEqual(Type.optionalDouble.order, 15)
        XCTAssertEqual(Type.optionalAny.order, 16)
        XCTAssertEqual(Type.optionalStruct("Test").order, 17)

        XCTAssertEqual(Type.optionalStringArray.order, 18)
        XCTAssertEqual(Type.optionalBoolArray.order, 19)
        XCTAssertEqual(Type.optionalIntArray.order, 20)
        XCTAssertEqual(Type.optionalDoubleArray.order, 21)
        XCTAssertEqual(Type.optionalAnyArray.order, 22)
        XCTAssertEqual(Type.optionalStructArray("Test").order, 23)
    }

    func testRawValueTypes() {
        XCTAssertEqual(Type.string.rawValue, "String")
        XCTAssertEqual(Type.bool.rawValue, "Bool")
        XCTAssertEqual(Type.int.rawValue, "Int")
        XCTAssertEqual(Type.double.rawValue, "Double")
        XCTAssertEqual(Type.any.rawValue, "Any")
        XCTAssertEqual(Type.struct("Test").rawValue, "Test")

        XCTAssertEqual(Type.stringArray.rawValue, "[String]")
        XCTAssertEqual(Type.boolArray.rawValue, "[Bool]")
        XCTAssertEqual(Type.intArray.rawValue, "[Int]")
        XCTAssertEqual(Type.doubleArray.rawValue, "[Double]")
        XCTAssertEqual(Type.anyArray.rawValue, "[Any]")
        XCTAssertEqual(Type.structArray("Test").rawValue, "[Test]")

        XCTAssertEqual(Type.optionalString.rawValue, "String?")
        XCTAssertEqual(Type.optionalBool.rawValue, "Bool?")
        XCTAssertEqual(Type.optionalInt.rawValue, "Int?")
        XCTAssertEqual(Type.optionalDouble.rawValue, "Double?")
        XCTAssertEqual(Type.optionalAny.rawValue, "Any?")
        XCTAssertEqual(Type.optionalStruct("Test").rawValue, "Test?")

        XCTAssertEqual(Type.optionalStringArray.rawValue, "[String?]")
        XCTAssertEqual(Type.optionalBoolArray.rawValue, "[Bool?]")
        XCTAssertEqual(Type.optionalIntArray.rawValue, "[Int?]")
        XCTAssertEqual(Type.optionalDoubleArray.rawValue, "[Double?]")
        XCTAssertEqual(Type.optionalAnyArray.rawValue, "[Any?]")
        XCTAssertEqual(Type.optionalStructArray("Test").rawValue, "[Test?]")
    }

    func testTypesArray() {
        XCTAssertEqual(Type.string.toArray(), Type.stringArray)
        XCTAssertEqual(Type.bool.toArray(), Type.boolArray)
        XCTAssertEqual(Type.int.toArray(), Type.intArray)
        XCTAssertEqual(Type.double.toArray(), Type.doubleArray)
        XCTAssertEqual(Type.any.toArray(), Type.anyArray)
        XCTAssertEqual(Type.struct("Test").toArray(), Type.structArray("Test"))

        XCTAssertEqual(Type.stringArray.toArray(), Type.stringArray)
        XCTAssertEqual(Type.boolArray.toArray(), Type.boolArray)
        XCTAssertEqual(Type.intArray.toArray(), Type.intArray)
        XCTAssertEqual(Type.doubleArray.toArray(), Type.doubleArray)
        XCTAssertEqual(Type.anyArray.toArray(), Type.anyArray)
        XCTAssertEqual(Type.structArray("Test").toArray(), Type.structArray("Test"))

        XCTAssertEqual(Type.optionalString.toArray(), Type.optionalStringArray)
        XCTAssertEqual(Type.optionalBool.toArray(), Type.optionalBoolArray)
        XCTAssertEqual(Type.optionalInt.toArray(), Type.optionalIntArray)
        XCTAssertEqual(Type.optionalDouble.toArray(), Type.optionalDoubleArray)
        XCTAssertEqual(Type.optionalAny.toArray(), Type.optionalAnyArray)
        XCTAssertEqual(Type.optionalStruct("Test").toArray(), Type.optionalStructArray("Test"))

        XCTAssertEqual(Type.optionalStringArray.toArray(), Type.optionalStringArray)
        XCTAssertEqual(Type.optionalBoolArray.toArray(), Type.optionalBoolArray)
        XCTAssertEqual(Type.optionalIntArray.toArray(), Type.optionalIntArray)
        XCTAssertEqual(Type.optionalDoubleArray.toArray(), Type.optionalDoubleArray)
        XCTAssertEqual(Type.optionalAnyArray.toArray(), Type.optionalAnyArray)
        XCTAssertEqual(Type.optionalStructArray("Test").toArray(), Type.optionalStructArray("Test"))
    }

    func testOptionalTypes() {
        XCTAssertEqual(Type.string.optional(), Type.optionalString)
        XCTAssertEqual(Type.bool.optional(), Type.optionalBool)
        XCTAssertEqual(Type.int.optional(), Type.optionalInt)
        XCTAssertEqual(Type.double.optional(), Type.optionalDouble)
        XCTAssertEqual(Type.any.optional(), Type.optionalAny)
        XCTAssertEqual(Type.struct("Test").optional(), Type.optionalStruct("Test"))

        XCTAssertEqual(Type.stringArray.optional(), Type.optionalStringArray)
        XCTAssertEqual(Type.boolArray.optional(), Type.optionalBoolArray)
        XCTAssertEqual(Type.intArray.optional(), Type.optionalIntArray)
        XCTAssertEqual(Type.doubleArray.optional(), Type.optionalDoubleArray)
        XCTAssertEqual(Type.anyArray.optional(), Type.optionalAnyArray)
        XCTAssertEqual(Type.structArray("Test").optional(), Type.optionalStructArray("Test"))

        XCTAssertEqual(Type.optionalString.optional(), Type.optionalString)
        XCTAssertEqual(Type.optionalBool.optional(), Type.optionalBool)
        XCTAssertEqual(Type.optionalInt.optional(), Type.optionalInt)
        XCTAssertEqual(Type.optionalDouble.optional(), Type.optionalDouble)
        XCTAssertEqual(Type.optionalAny.optional(), Type.optionalAny)
        XCTAssertEqual(Type.optionalStruct("Test").optional(), Type.optionalStruct("Test"))

        XCTAssertEqual(Type.optionalStringArray.optional(), Type.optionalStringArray)
        XCTAssertEqual(Type.optionalBoolArray.optional(), Type.optionalBoolArray)
        XCTAssertEqual(Type.optionalIntArray.optional(), Type.optionalIntArray)
        XCTAssertEqual(Type.optionalDoubleArray.optional(), Type.optionalDoubleArray)
        XCTAssertEqual(Type.optionalAnyArray.optional(), Type.optionalAnyArray)
        XCTAssertEqual(Type.optionalStructArray("Test").optional(), Type.optionalStructArray("Test"))
    }

    func testUnique() {
        var result: [Type]
        var expectation: [Type]

        result = [.string, .string, .string, .string, .string]
        expectation = [.string]
        XCTAssertEqual(result.unique(), expectation)

        result = [.optionalIntArray, .string, .string]
        expectation = [.string, .optionalIntArray]
        XCTAssertEqual(result.unique(), expectation)

        result = [.optionalStruct("A"), .optionalStruct("B"), .optionalStructArray("C"), .optionalStructArray("D")]
        XCTAssertEqual(result.unique().count, result.count)
    }

    func testHasOptional() {
        var result: [Type]
        var expectation: Bool

        result = [
            .string, .int, .double, .any, .struct("Test"),
            .stringArray, .intArray, .anyArray, .structArray("Test")
        ]
        expectation = false
        XCTAssertEqual(result.hasOptional(), expectation)

        result = [
            .optionalString, .optionalInt, .optionalAny, .optionalStruct("Test"),
            .optionalStringArray, .optionalIntArray, .optionalAnyArray, .optionalStructArray("Test")
        ]
        expectation = true
        XCTAssertEqual(result.hasOptional(), expectation)
    }

    func testSumType() {
        var result: [Type]
        var expectation: Type

        result = []
        expectation = .optionalAnyArray
        XCTAssertEqual(result.sumType(), expectation)

        result = [
            .string, .string, .string, .string, .string
        ]
        expectation = .stringArray
        XCTAssertEqual(result.sumType(), expectation)

        result = [
            .string, .string, .optionalString
        ]
        expectation = .optionalStringArray
        XCTAssertEqual(result.sumType(), expectation)

        result = [
            .int, .int, .optionalInt
        ]
        expectation = .optionalIntArray
        XCTAssertEqual(result.sumType(), expectation)

        result = [
            .boolArray, .boolArray, .boolArray
        ]
        expectation = .boolArray
        XCTAssertEqual(result.sumType(), expectation)

        result = [
            .doubleArray, .doubleArray, .optionalDoubleArray
        ]
        expectation = .optionalDoubleArray
        XCTAssertEqual(result.sumType(), expectation)
        
        result = [
            .string, .int, .double
        ]
        expectation = .anyArray
        XCTAssertEqual(result.sumType(), expectation)

        result = [
            .string, .int, .optionalBool
        ]
        expectation = .optionalAnyArray
        XCTAssertEqual(result.sumType(), expectation)
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
