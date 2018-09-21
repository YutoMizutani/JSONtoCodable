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
        XCTAssertEqual(self.base.decisionType("True", isString: true), .string)
        XCTAssertEqual(self.base.decisionType("false", isString: true), .string)
        XCTAssertEqual(self.base.decisionType("0", isString: true), .string)
        XCTAssertEqual(self.base.decisionType("1000", isString: true), .string)
        XCTAssertEqual(self.base.decisionType("1.0", isString: true), .string)
        XCTAssertEqual(self.base.decisionType("1000.5", isString: true), .string)
        XCTAssertEqual(self.base.decisionType("nil", isString: true), .string)
        XCTAssertEqual(self.base.decisionType("NULL", isString: true), .string)
        XCTAssertEqual(self.base.decisionType("Hello", isString: true), .string)

        XCTAssertEqual(self.base.decisionType("True", isString: false), .bool)
        XCTAssertEqual(self.base.decisionType("false", isString: false), .bool)
        XCTAssertEqual(self.base.decisionType("0", isString: false), .int)
        XCTAssertEqual(self.base.decisionType("1000", isString: false), .int)
        XCTAssertEqual(self.base.decisionType("1.0", isString: false), .double)
        XCTAssertEqual(self.base.decisionType("1000.5", isString: false), .double)
        XCTAssertEqual(self.base.decisionType("nil", isString: false), .optionalAny)
        XCTAssertEqual(self.base.decisionType("NULL", isString: false), .optionalAny)
        XCTAssertEqual(self.base.decisionType("Hello", isString: false), .any)
    }

    func testCreateStructFrame() {
        var key: String
        var expectation: String

        key = "HelloWorld"
        XCTAssertEqual(self.base.createStructFrame(key).suffix, "}")

        key = "HelloWorld"
        expectation = "struct HelloWorld: Codable {"
        XCTAssertEqual(self.base.createStructFrame(key).prefix, expectation)
        key = "HelloWorld"
        expectation = "fileprivate struct HelloWorld: Codable {"
        self.base.config.accessModifer = .fileprivate
        XCTAssertEqual(self.base.createStructFrame(key).prefix, expectation)

        // NOTE: There will occur compile errors when create the .swift file, but it is not interested this method
        key = "1234"
        expectation = "open struct 1234: Codable {"
        self.base.config.accessModifer = .open
        XCTAssertEqual(self.base.createStructFrame(key).prefix, expectation)
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
        self.base.config.caseType = (variable: CaseType.pascal, struct: CaseType.camel)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("HelloWorld", .struct)
        expectation = "let HELLO_WORLD: hello_world"
        self.base.config.caseType = (variable: CaseType.screamingSnake, struct: CaseType.snake)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("HELLO_WORLD", .struct)
        expectation = "let helloWorld: HELLO_WORLD"
        self.base.config.caseType = (variable: CaseType.camel, struct: CaseType.screamingSnake)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("HELLO_WORLD", .struct)
        expectation = "let hello_world: HelloWorld"
        self.base.config.caseType = (variable: CaseType.snake, struct: CaseType.pascal)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)

        // NOTE: There will occur compile errors when create the .swift file, but it is not interested this method
        seed = ("HelloWorld", .struct)
        expectation = "let HelloWorld: HelloWorld"
        self.base.config.caseType = (variable: CaseType.pascal, struct: CaseType.pascal)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
        seed = ("1234", .struct)
        expectation = "let 1234: 1234"
        self.base.config.caseType = (variable: CaseType.camel, struct: CaseType.pascal)
        XCTAssertEqual(self.base.createImmutable(seed), expectation)
    }

    func testCreateCodingKey() {
        let jsonKey: String = "HelloWorld"
        var expectation: String

        expectation = "case HelloWorld"
        self.base.config.caseType.variable = .pascal
        XCTAssertEqual(self.base.createCodingKey(jsonKey), expectation)
        expectation = "case helloWorld = \"HelloWorld\""
        self.base.config.caseType.variable = .camel
        XCTAssertEqual(self.base.createCodingKey(jsonKey), expectation)
        expectation = "case hello_world = \"HelloWorld\""
        self.base.config.caseType.variable = .snake
        XCTAssertEqual(self.base.createCodingKey(jsonKey), expectation)
        expectation = "case HELLO_WORLD = \"HelloWorld\""
        self.base.config.caseType.variable = .screamingSnake
        XCTAssertEqual(self.base.createCodingKey(jsonKey), expectation)
    }

    func testCreateCodingKeyScope() {
        var keys: [String]
        var expectation: String

        let hello = "case hello = \"Hello\""
        keys = Array<String>(repeating: hello, count: 1)
        expectation = """
        private enum CodingKeys: String, CodingKey {
            case hello = "Hello"
        }
        """
        XCTAssertEqual(self.base.createCodingKeyScope(keys), expectation)
        keys = Array<String>(repeating: hello, count: 2)
        expectation = """
        private enum CodingKeys: String, CodingKey {
            case hello = "Hello"
            case hello = "Hello"
        }
        """
        XCTAssertEqual(self.base.createCodingKeyScope(keys), expectation)
        keys = Array<String>(repeating: hello, count: 3)
        expectation = """
        private enum CodingKeys: String, CodingKey {
            case hello = "Hello"
            case hello = "Hello"
            case hello = "Hello"
        }
        """
        XCTAssertEqual(self.base.createCodingKeyScope(keys), expectation)
    }

    func testCreateStructScope() {
        let structTitle: String = "Result"
        var values: [String]
        var seed: (frame: JSONtoCodableMock.Property, immutables: [String], codingKeys: [String])
        var expectation: String

        values = ["Single1", "Single2"]
        seed = (
            frame: self.base.createStructFrame(structTitle),
            immutables: values.map { (key: $0, type: .string) }.map { self.base.createImmutable($0) },
            codingKeys: values.map { self.base.createCodingKey($0) }
        )
        expectation = """
        struct Result: Codable {
            let single1: String
            let single2: String

            private enum CodingKeys: String, CodingKey {
                case single1 = "Single1"
                case single2 = "Single2"
            }
        }
        """
        XCTAssertEqual(self.base.createStructScope(seed.frame, immutables: seed.immutables, codingKeys: seed.codingKeys), expectation)

        values = ["single1", "single2", "single3"]
        seed = (
            frame: self.base.createStructFrame(structTitle),
            immutables: values.map { (key: $0, type: .string) }.map { self.base.createImmutable($0) },
            codingKeys: []
        )
        expectation = """
        struct Result: Codable {
            let single1: String
            let single2: String
            let single3: String
        }
        """
        XCTAssertEqual(self.base.createStructScope(seed.frame, immutables: seed.immutables, codingKeys: seed.codingKeys), expectation)

        var frame: JSONtoCodableMock.Property
        var internalStructString: String

        values = ["Single1", "Single2", "Single3"]
        frame = self.base.createStructFrame(structTitle)
        internalStructString = "struct Single2: Codable {\n    let double1: String\n\n    private enum CodingKeys: String, CodingKey {\n        case double1 = \"Double1\"\n    }\n}"
        seed = (
            frame: (frame.prefix, [internalStructString], frame.suffix),
            immutables: values.map { (key: $0, type: $0 != "Single2" ? .string : .struct) }.map { self.base.createImmutable($0) },
            codingKeys: values.map { self.base.createCodingKey($0) }
        )
        expectation = """
        struct Result: Codable {
            let single1: String
            let single2: Single2
            let single3: String

            struct Single2: Codable {
                let double1: String

                private enum CodingKeys: String, CodingKey {
                    case double1 = "Double1"
                }
            }

            private enum CodingKeys: String, CodingKey {
                case single1 = "Single1"
                case single2 = "Single2"
                case single3 = "Single3"
            }
        }
        """
        XCTAssertEqual(self.base.createStructScope(seed.frame, immutables: seed.immutables, codingKeys: seed.codingKeys), expectation)

        values = ["Single1", "Single2", "Single3"]
        frame = self.base.createStructFrame(structTitle)
        internalStructString = "struct Single2: Codable {\n    let double1: String\n    let double2: Double2\n    let double3: String\n\n    struct Double2: Codable {\n        let triple1: String\n\n        private enum CodingKeys: String, CodingKey {\n            case triple1 = \"Triple1\"\n        }\n    }\n\n    private enum CodingKeys: String, CodingKey {\n        case double1 = \"Double1\"\n        case double2 = \"Double2\"\n        case double3 = \"Double3\"\n    }\n}"
        seed = (
            frame: (frame.prefix, [internalStructString], frame.suffix),
            immutables: values.map { (key: $0, type: $0 != "Single2" ? .string : .struct) }.map { self.base.createImmutable($0) },
            codingKeys: values.map { self.base.createCodingKey($0) }
        )
        expectation = """
        struct Result: Codable {
            let single1: String
            let single2: Single2
            let single3: String

            struct Single2: Codable {
                let double1: String
                let double2: Double2
                let double3: String

                struct Double2: Codable {
                    let triple1: String

                    private enum CodingKeys: String, CodingKey {
                        case triple1 = "Triple1"
                    }
                }

                private enum CodingKeys: String, CodingKey {
                    case double1 = "Double1"
                    case double2 = "Double2"
                    case double3 = "Double3"
                }
            }

            private enum CodingKeys: String, CodingKey {
                case single1 = "Single1"
                case single2 = "Single2"
                case single3 = "Single3"
            }
        }
        """
        XCTAssertEqual(self.base.createStructScope(seed.frame, immutables: seed.immutables, codingKeys: seed.codingKeys), expectation)
    }
}
