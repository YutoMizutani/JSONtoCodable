//
//  NestingTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import XCTest
@testable import JSONtoCodable

class NestingTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodable()
    }

    func testNestSingle() {
        let json: String = """
        {
            "Single1": "Hello, world!!",
            "Single2": "Hello, world!!"
        }
        """
        let expectation: String = """
        public struct Result: Codable {
            public let single1: String
            public let single2: String

            private enum CodingKeys: String, CodingKey {
                case single1 = "Single1"
                case single2 = "Single2"
            }
        }
        """
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testNestDouble() {
        let json: String = """
        {
            "Single1": "Hello, world!!",
            "Single2": {
                "Double1": "Hello, world!!"
            },
            "Single3": "Hello, world!!"
        }
        """
        let expectation: String = """
        public struct Result: Codable {
            public let single1: String
            public let single2: Single2
            public let single3: String

            public struct Single2: Codable {
                public let double1: String

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
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }

    func testNestTriple() {
        let json: String = """
        {
            "Single1": "Hello, world!!",
            "Single2": {
                "Double1": "Hello, world!!",
                "Double2": {
                    "Triple1": "Hello, world!!"
                },
                "Double3": "Hello, world!!"
            }
            "Single3": "Hello, world!!"
        }
        """
        let expectation: String = """
        public struct Result: Codable {
            public let single1: String
            public let single2: Single2
            public let single3: String

            public struct Single2: Codable {
                public let double1: String
                public let double2: Double2
                public let double3: String

                public struct Double2: Codable {
                    public let triple1: String

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
        let result: String? = try? self.base.generate(json)
        XCTAssertEqual(result, expectation)
    }
}
