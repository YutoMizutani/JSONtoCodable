import XCTest

import jcTests

var tests = [XCTestCaseEntry]()
tests += jcTests.allTests()
XCTMain(tests)