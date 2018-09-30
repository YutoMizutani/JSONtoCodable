//
//  ReservedWordsTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/25.
//

import XCTest
@testable import JSONtoCodable

/**
 ReservedWordsTests

 - seealso:
 https://github.com/apple/swift/blob/master/docs/archive/LangRefNew.rst#reserved-keywords
 */
class ReservedWordsTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodable()
    }

    func testLowerDeclarationsAndTypeKeywords() {
        let json: String = """
        {
            "class": "Hello, world!!"
            "destructor": "Hello, world!!"
            "extension": "Hello, world!!"
            "import": "Hello, world!!"
            "init": "Hello, world!!"
            "func": "Hello, world!!"
            "enum": "Hello, world!!"
            "protocol": "Hello, world!!"
            "struct": "Hello, world!!"
            "subscript": "Hello, world!!"
            "typealias": "Hello, world!!"
            "var": "Hello, world!!"
            "where": "Hello, world!!"
        }
        """
        let expectation: String = """
        public struct Result: Codable {
            public let `class`: String
            public let `destructor`: String
            public let `extension`: String
            public let `import`: String
            public let `init`: String
            public let `func`: String
            public let `enum`: String
            public let `protocol`: String
            public let `struct`: String
            public let `subscript`: String
            public let `typealias`: String
            public let `var`: String
            public let `where`: String
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testUpperDeclarationsAndTypeKeywords() {
        let json: String = """
        {
            "Type": "Hello, world!!"
        }
        """
        let expectation: String = """
        public struct Result: Codable {
            public let `Type`: String
        }
        """
        self.base.config.caseType.variable = .pascal
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testStatements() {
        let json: String = """
        {
            "break": "Hello, world!!"
            "case": "Hello, world!!"
            "continue": "Hello, world!!"
            "default": "Hello, world!!"
            "do": "Hello, world!!"
            "else": "Hello, world!!"
            "if": "Hello, world!!"
            "in": "Hello, world!!"
            "for": "Hello, world!!"
            "return": "Hello, world!!"
            "switch": "Hello, world!!"
            "then": "Hello, world!!"
            "while": "Hello, world!!"
        }
        """
        let expectation: String = """
        public struct Result: Codable {
            public let `break`: String
            public let `case`: String
            public let `continue`: String
            public let `default`: String
            public let `do`: String
            public let `else`: String
            public let `if`: String
            public let `in`: String
            public let `for`: String
            public let `return`: String
            public let `switch`: String
            public let `then`: String
            public let `while`: String
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testLowerExpressions() {
        let json: String = """
        {
            "as": "Hello, world!!"
            "is": "Hello, world!!"
            "new": "Hello, world!!"
            "super": "Hello, world!!"
            "self": "Hello, world!!"
            "type": "Hello, world!!"
        }
        """
        let expectation: String = """
        public struct Result: Codable {
            public let `as`: String
            public let `is`: String
            public let `new`: String
            public let `super`: String
            public let `self`: String
            public let `type`: String
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testUpperExpressions() {
        let json: String = """
        {
            "Self": "Hello, world!!"
        }
        """
        let expectation: String = """
        public struct Result: Codable {
            public let `Self`: String
        }
        """
        self.base.config.caseType.variable = .pascal
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }
}
