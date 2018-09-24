//
//  MergeWithOptionalTests.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/24.
//

import XCTest
@testable import JSONtoCodable

class MergeWithOptionalTests: XCTestCase {
    func testEmpty() {
        let seed: [[String]] = []
        let expectation: [String] = []
        let result: [String] = seed.mergeWithOptional()
        XCTAssertEqual(result, expectation)
    }

    func testSingle() {
        let seed: [[String]] = [["a"]]
        let expectation: [String] = ["a"]
        let result: [String] = seed.mergeWithOptional()
        XCTAssertEqual(result, expectation)
    }

    func testOptional() {
        let seed: [[String]] = [
            ["a", "b"],
            ["a", "c"],
            ]
        let expectation: [String] = ["a", "b?", "c?"]
        let result: [String] = seed.mergeWithOptional()
        XCTAssertEqual(result, expectation)
    }

    func testOptionalWithEmptyArrayFirst() {
        let seed: [[String]] = [
            [],
            ["a", "b"],
            ]
        let expectation: [String] = ["a?", "b?"]
        let result: [String] = seed.mergeWithOptional()
        XCTAssertEqual(result, expectation)
    }

    func testOptionalWithEmptyArrayLast() {
        let seed: [[String]] = [
            ["a", "b"],
            [],
            ]
        let expectation: [String] = ["a?", "b?"]
        let result: [String] = seed.mergeWithOptional()
        XCTAssertEqual(result, expectation)
    }

    func testOptionalWithReturnNonOptionals() {
        let seed: [[String]] = [
            ["a", "b", "d"],
            ["a", "c", "d"],
            ]
        let expectation: [String] = ["a", "b?", "c?", "d"]
        let result: [String] = seed.mergeWithOptional()
        XCTAssertEqual(result, expectation)
    }

    func testOptionalTripleWithReturnNonOptionals() {
        let seed: [[String]] = [
            ["a", "c", "d"],
            ["a", "b", "d"],
            ["a", "e", "d"],
            ]
        let expectation: [String] = ["a", "c?", "b?", "e?", "d"]
        let result: [String] = seed.mergeWithOptional()
        XCTAssertEqual(result, expectation)
    }

    func testOptionalTripleWithDifferentCount() {
        let seed: [[String]] = [
            ["a"],
            ["b", "d"],
            ["e", "d"],
            ]
        let expectation: [String] = ["a?", "b?", "e?", "d?"]
        let result: [String] = seed.mergeWithOptional()
        XCTAssertEqual(result, expectation)
    }

    func testOptionalTripleWithDifferentAll() {
        let seed: [[String]] = [
            ["a", "b", "c"],
            ["d", "e", "f"],
            ["g", "h", "i"],
            ]
        let expectation: [String] = ["a?", "b?", "c?", "d?", "e?", "f?", "g?", "h?", "i?"]
        let result: [String] = seed.mergeWithOptional()
        XCTAssertEqual(result, expectation)
    }
}
