//
//  MergeStructTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/30.
//

import XCTest
@testable import JSONtoCodable

class MergeStructTests: XCTestCase {
    var base: JSONtoCodable!

    override func setUp() {
        super.setUp()
        self.base = JSONtoCodable()
    }

    func testDuplicatedArrayObject() {
        let `struct`: String = """
        public struct Result: Codable {
            public let object: Object

            public struct Object: Codable {
                public let text: String
                public let arrayObject: [ArrayObject]

                public struct ArrayObject: Codable {
                    public let number: Int
                }

                public struct ArrayObject: Codable {
                    public let text: String
                    public let number: Int

                    private enum CodingKeys: String, CodingKey {
                        case text
                        case number = "Number"
                    }
                }

                private enum CodingKeys: String, CodingKey {
                    case text
                    case arrayObject = "ArrayObject"
                }
            }

            private enum CodingKeys: String, CodingKey {
                case object = "Object"
            }
        }
        """
        let expectation: String = """
        public struct Result: Codable {
            public let object: Object

            public struct Object: Codable {
                public let text: String
                public let arrayObject: [ArrayObject]

                public struct ArrayObject: Codable {
                    public let text: String?
                    public let number: Int

                    private enum CodingKeys: String, CodingKey {
                        case text
                        case number = "Number"
                    }
                }

                private enum CodingKeys: String, CodingKey {
                    case text
                    case arrayObject = "ArrayObject"
                }
            }

            private enum CodingKeys: String, CodingKey {
                case object = "Object"
            }
        }
        """
        let result: String = self.base.mergeStructs(`struct`)
        XCTAssertEqual(result, expectation)
    }
}
