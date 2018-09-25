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
        struct Result: Codable {
            let `class`: String
            let `destructor`: String
            let `extension`: String
            let `import`: String
            let `init`: String
            let `func`: String
            let `enum`: String
            let `protocol`: String
            let `struct`: String
            let `subscript`: String
            let `typealias`: String
            let `var`: String
            let `where`: String
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
        struct Result: Codable {
            let `Type`: String
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
        struct Result: Codable {
            let `break`: String
            let `case`: String
            let `continue`: String
            let `default`: String
            let `do`: String
            let `else`: String
            let `if`: String
            let `in`: String
            let `for`: String
            let `return`: String
            let `switch`: String
            let `then`: String
            let `while`: String
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
        struct Result: Codable {
            let `as`: String
            let `is`: String
            let `new`: String
            let `super`: String
            let `self`: String
            let `type`: String
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
        struct Result: Codable {
            let `Self`: String
        }
        """
        self.base.config.caseType.variable = .pascal
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }
}
