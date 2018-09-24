//
//  MergePropertiesTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/24.
//

import XCTest
@testable import JSONtoCodable

class MergePropertiesTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        self.base = JSONtoCodable()
    }

    func testEmpty() {
        let properties: [Property] = []
        XCTAssertNil(self.base.merge(properties))
    }

    func testSingle() {
        let property: Property = Property("Result")
        let properties: [Property] = [property]
        let expectation: Property = property
        let result = self.base.merge(properties)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, expectation)
    }

    func testSameProperties() {
        let property: Property = Property("Result")
        let properties: [Property] = [Property](repeating: property, count: 5)
        let expectation: Property = property
        let result = self.base.merge(properties)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, expectation)
    }

    func testSameJSONProperties() {
        let json1: String = """
        {
            "a": 1
            "b": 2
        }
        """
        let json2: String = """
        {
            "a": 1
            "b": 2
        }
        """
        let prop1 = try? self.base.generateProperty(json1)
        let prop2 = try? self.base.generateProperty(json2)
        XCTAssertNotNil(prop1)
        XCTAssertNotNil(prop2)
        let properties: [Property] = [prop1!, prop2!]
        let expectation: Property = prop1!
        let result = self.base.merge(properties)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, expectation)
    }

    func testDifferentJSONProperties() {
        let json1: String = """
        {
            "a": 1
            "b": 2
        }
        """
        let json2: String = """
        {
            "a": 1
            "c": 3
        }
        """
        let prop1 = try? self.base.generateProperty(json1)
        let prop2 = try? self.base.generateProperty(json2)
        XCTAssertNotNil(prop1)
        XCTAssertNotNil(prop2)
        let properties: [Property] = [prop1!, prop2!]
        let expectation: Property = prop1!
        let result = self.base.merge(properties)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, expectation)
        let resultText: String = self.base.createStructScope(result!)
        let expectationText: String = """
        struct Result: Codable {
            let a: Int
            let b: Int?
            let c: Int?
        }
        """
        XCTAssertEqual(resultText, expectationText)
    }

    func testDifferentJSONPropertiesWithReturnNonOptionals() {
        let json1: String = """
        {
            "a": 1
            "b": 2
            "d": 4
        }
        """
        let json2: String = """
        {
            "a": 1
            "c": 3
            "d": 4
        }
        """
        let prop1 = try? self.base.generateProperty(json1)
        let prop2 = try? self.base.generateProperty(json2)
        XCTAssertNotNil(prop1)
        XCTAssertNotNil(prop2)
        let properties: [Property] = [prop1!, prop2!]
        let expectation: Property = prop1!
        let result = self.base.merge(properties)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, expectation)
        let resultText: String = self.base.createStructScope(result!)
        let expectationText: String = """
        struct Result: Codable {
            let a: Int
            let b: Int?
            let c: Int?
            let d: Int
        }
        """
        XCTAssertEqual(resultText, expectationText)
    }
}
