import XCTest

import simpleHttpTests

var tests = [XCTestCaseEntry]()
tests += simpleHttpTests.allTests()
XCTMain(tests)
