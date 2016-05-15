//
//  ViewController.swift
//  Calculator
//
//  Created by Lena on 3/22/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var display: UILabel!
  @IBOutlet weak var history: UILabel!
  
  var userIsInTheMiddleOfTypingANumber = false
  var brain = CalculatorBrain()
  var displayValue: Double? {
    get {
      return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
    }
    set {
      if let value = newValue {
        display.text = String(format: "%g", value)
      } else {
        display.text = "0"
      }
      userIsInTheMiddleOfTypingANumber = false
    }
  }
  
  // Append digit or dot
  @IBAction func appendChar(sender: UIButton) {
    let char = sender.currentTitle!
    
    if userIsInTheMiddleOfTypingANumber {
      if char == "." && display.text?.rangeOfString(".") != nil {
        return // ignore "." if already typed
      }
      display.text = display.text! + char
    } else {
      display.text = char
      userIsInTheMiddleOfTypingANumber = true
    }
  }

  @IBAction func appendConstant(sender: UIButton) {
    if let constant = sender.currentTitle {
      if let result = brain.pushConstant(constant) {
        displayValue = result
        history.text = brain.description
      }
    }
  }
  
  @IBAction func operate(sender: UIButton) {
    if userIsInTheMiddleOfTypingANumber {
      enter()
    }
    
    if let operation = sender.currentTitle {
      if let result = brain.performOperation(operation) {
        displayValue = result
        history.text = brain.description + " ="
      }
    }
  }
  
  @IBAction func changeSign() {
    if displayValue > 0 {
      display.text = "-" + display.text!
    } else if displayValue < 0 {
      display.text!.removeAtIndex(display.text!.startIndex)
    }
  }
  
  @IBAction func backspace() {
    guard display.text?.characters.count > 1 else {
      display.text = "0"
      userIsInTheMiddleOfTypingANumber = false
      return
    }
    display.text = String(display.text!.characters.dropLast())
  }
  
  @IBAction func clear() {
    userIsInTheMiddleOfTypingANumber = false
    display.text = "0"
    history.text = ""
    brain.clearStack()
  }
  
  @IBAction func enter() {
    userIsInTheMiddleOfTypingANumber = false
    if let value = displayValue {
      if let result = brain.pushOperand(value) {
        displayValue = result
        history.text = brain.description
      }
    }
  }
  

  
}

