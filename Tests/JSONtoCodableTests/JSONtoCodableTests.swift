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

        seed = ("HelloWorld", .struct)
        expectation = "let HelloWorld: helloWorld"
        self.base.config.caseType = (struct: CaseType.camel, variable: CaseType.pascal)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("HelloWorld", .struct)
        expectation = "let HELLO_WORLD: hello_world"
        self.base.config.caseType = (struct: CaseType.snake, variable: CaseType.screamingSnake)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("HELLO_WORLD", .struct)
        expectation = "let helloWorld: HELLO_WORLD"
        self.base.config.caseType = (struct: CaseType.screamingSnake, variable: CaseType.camel)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("HELLO_WORLD", .struct)
        expectation = "let hello_world: HelloWorld"
        self.base.config.caseType = (struct: CaseType.pascal, variable: CaseType.snake)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)

        // NOTE: There will occur compile errors when create the .swift file, but it is not interested this method
        seed = ("HelloWorld", .struct)
        expectation = "let HelloWorld: HelloWorld"
        self.base.config.caseType = (struct: CaseType.pascal, variable: CaseType.pascal)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("1234", .struct)
        expectation = "let 1234: 1234"
        self.base.config.caseType = (struct: CaseType.pascal, variable: CaseType.camel)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
    }
}
