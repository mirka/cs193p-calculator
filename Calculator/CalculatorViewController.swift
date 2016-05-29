//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Lena on 3/22/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

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
        display.text = " "
      }
      userIsInTheMiddleOfTypingANumber = false
    }
  }

  func updateHistory() {
    history.text = brain.description
    if !userIsInTheMiddleOfTypingANumber && history.text != "" {
      history.text? += " ="
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
    updateHistory()
  }

  @IBAction func appendConstant(sender: UIButton) {
    if let constant = sender.currentTitle {
      if let result = brain.pushConstant(constant) {
        displayValue = result
        updateHistory()
      }
    }
  }

  @IBAction func setVariable() {
    if let value = displayValue {
      brain.variableValues["M"] = value
      userIsInTheMiddleOfTypingANumber = false
      displayValue = brain.evaluate()
      updateHistory()
    }
  }

  @IBAction func getVariable() {
    brain.pushOperand("M")
    displayValue = brain.evaluate()
    updateHistory()
  }
  
  @IBAction func operate(sender: UIButton) {
    if userIsInTheMiddleOfTypingANumber {
      enter()
    }
    
    if let operation = sender.currentTitle {
      displayValue = brain.performOperation(operation)
      updateHistory()
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
    if !userIsInTheMiddleOfTypingANumber {
      displayValue = brain.removeLastStackItem()
      if brain.opStackIsEmpty { display.text = "0" }
      updateHistory()
      return
    }
    guard display.text?.characters.count > 1 else {
      display.text = "0"
      userIsInTheMiddleOfTypingANumber = false
      return
    }
    display.text = String(display.text!.characters.dropLast())
  }
  
  @IBAction func clear() {
    userIsInTheMiddleOfTypingANumber = false
    brain.clearStack()
    display.text = "0"
    updateHistory()
    brain.variableValues.removeAll()
  }
  
  @IBAction func enter() {
    userIsInTheMiddleOfTypingANumber = false
    if let value = displayValue {
      if let result = brain.pushOperand(value) {
        displayValue = result
        updateHistory()
      }
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var destination = segue.destinationViewController
    if let navigationController = destination as? UINavigationController {
      destination = navigationController.visibleViewController!
    }
    if let graphViewController = destination as? GraphViewDataSource {
      graphViewController.program = brain.program
    }
  }
  
}

