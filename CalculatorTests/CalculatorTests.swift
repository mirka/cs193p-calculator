//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Lena on 3/22/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {

  var brain = CalculatorBrain()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
      brain.clearStack()
    }

  func testFunctionNotation() {
    brain.pushOperand(10)
    brain.performOperation("cos")
    XCTAssertEqual(brain.description, "cos(10)")
  }

  func testInfixNotation() {
    brain.pushOperand(3)
    brain.pushOperand(5)
    brain.performOperation("−")
    XCTAssertEqual(brain.description, "3−5")
  }

  func testDisplayUnadornedConstant() {
    brain.pushOperand("π")
    XCTAssertEqual(brain.description, "π")
  }

//  func testDisplayUnadornedVariable() {
//    brain.pushVariable("x")
//    XCTAssertEqual(brain.description, "x")
//  }

  func testCombination1() {
    brain.pushOperand(10)
    brain.performOperation("√")
    brain.pushOperand(3)
    brain.performOperation("+")
    XCTAssertEqual(brain.description, "√(10)+3")
  }

  func testCombination2() {
    brain.pushOperand(3)
    brain.pushOperand(5)
    brain.performOperation("+")
    brain.performOperation("√")
    XCTAssertEqual(brain.description, "√(3+5)")
  }

  func testCombination3() {
    brain.pushOperand(3)
    brain.pushOperand(5)
    brain.pushOperand(4)
    brain.performOperation("+")
    brain.performOperation("+")
    XCTAssertEqual(brain.description, "3+5+4")
  }

  func testCombination4() {
    brain.pushOperand(3)
    brain.pushOperand(5)
    brain.performOperation("√")
    brain.performOperation("+")
    brain.performOperation("√")
    brain.pushOperand(6)
    brain.performOperation("÷")
    XCTAssertEqual(brain.description, "√(3+√(5))÷6")
  }

  func testMissingOperands() {
    brain.pushOperand(3)
    brain.performOperation("+")
    XCTAssertEqual(brain.description, "?+3")
  }

  func testMultipleCompleteExpressions() {
    brain.pushOperand(3)
    brain.pushOperand(5)
    brain.performOperation("+")
    brain.performOperation("√")
    brain.pushOperand("π")
    brain.performOperation("cos")
    XCTAssertEqual(brain.description, "√(3+5),cos(π)")
  }

  func testParens1() {
    brain.pushOperand(3)
    brain.pushOperand(5)
    brain.pushOperand(4)
    brain.performOperation("+")
    brain.performOperation("×")
    XCTAssertEqual(brain.description, "3×(5+4)")
  }

  func testParens2() {
    brain.pushOperand(3)
    brain.pushOperand(6)
    brain.performOperation("+")
    brain.pushOperand(3)
    brain.performOperation("÷")
    XCTAssertEqual(brain.description, "(3+6)÷3")
  }

  func testMemoryButton() {
    brain.pushOperand(7)
    brain.pushOperand("M")
    brain.performOperation("+")
    brain.performOperation("√")
    XCTAssertEqual(brain.description, "√(7+M)")
  }

}
