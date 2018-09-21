//
//  JSONtoCodableTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/21.
//

import XCTest
@testable import JSONtoCodable

class JSONtoCodableTests: XCTestCase {
    var base: JSONtoCodableMock!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodableMock()
    }

    func testDecisionType() {
        XCTAssertEqual(self.base.decisionType(value: "True", isString: true), .string)
        XCTAssertEqual(self.base.decisionType(value: "false", isString: true), .string)
        XCTAssertEqual(self.base.decisionType(value: "0", isString: true), .string)
        XCTAssertEqual(self.base.decisionType(value: "1000", isString: true), .string)
        XCTAssertEqual(self.base.decisionType(value: "1.0", isString: true), .string)
        XCTAssertEqual(self.base.decisionType(value: "1000.5", isString: true), .string)
        XCTAssertEqual(self.base.decisionType(value: "nil", isString: true), .string)
        XCTAssertEqual(self.base.decisionType(value: "NULL", isString: true), .string)
        XCTAssertEqual(self.base.decisionType(value: "Hello", isString: true), .string)

        XCTAssertEqual(self.base.decisionType(value: "True", isString: false), .bool)
        XCTAssertEqual(self.base.decisionType(value: "false", isString: false), .bool)
        XCTAssertEqual(self.base.decisionType(value: "0", isString: false), .int)
        XCTAssertEqual(self.base.decisionType(value: "1000", isString: false), .int)
        XCTAssertEqual(self.base.decisionType(value: "1.0", isString: false), .double)
        XCTAssertEqual(self.base.decisionType(value: "1000.5", isString: false), .double)
        XCTAssertEqual(self.base.decisionType(value: "nil", isString: false), .optionalAny)
        XCTAssertEqual(self.base.decisionType(value: "NULL", isString: false), .optionalAny)
        XCTAssertEqual(self.base.decisionType(value: "Hello", isString: false), .any)
    }

    func testCreateImmutable() {
        var seed: (key: String, type: Type)
        var expectation: String

        self.base.config.caseType.struct = CaseType.pascal

        seed = ("hello", .string)
        expectation = "let hello: String"
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("hello", .bool)
        expectation = "let hello: Bool"
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("hello", .int)
        expectation = "let hello: Int"
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("hello", .double)
        expectation = "let hello: Double"
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("hello", .optionalAny)
        expectation = "let hello: Any?"
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("hello", .any)
        expectation = "let hello: Any"
        XCTAssertEqual(self.base.createImmutable(seed), expectation)

        seed = ("hello", .struct)
        expectation = "let hello: Hello"
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("Hello", .struct)
        expectation = "let Hello: Hello"
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("hello", .struct)
        expectation = "let hello: hello"
        self.base.config.caseType.struct = CaseType.camel
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
    }
}
