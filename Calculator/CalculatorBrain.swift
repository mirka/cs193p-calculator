//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Lena on 3/24/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import Foundation

class CalculatorBrain {
  private var opStack = [Op]()
  private var knownOps = Dictionary<String, Op>()
  private var variableValues = Dictionary<String, Double>()

  var description: String {
    func stringify(ops: [Op]) -> (result: String, remainingOps: [Op]) {
      if !ops.isEmpty {
        var remainingOps = ops
        let op = remainingOps.removeLast()

        switch op {
        case .Operand:
          return ("\(op)", remainingOps)
        case .Variable(let operand):
          return ("\(operand)", remainingOps)
        case .UnaryOperation(let operation, _):
          let (string, remainingOps) = stringify(remainingOps)
          let expression = "\(operation)(\(string))"
          return (expression, remainingOps)
        case .BinaryOperation(let operation, _):
          let (op1String, op1Remaining) = stringify(remainingOps)
          let (op2String, op2Remaining) = stringify(op1Remaining)
          var expression = ""
          if op.precedence > remainingOps.last?.precedence {
            expression = "\(op2String)\(operation)(\(op1String))"
          } else {
            expression = "\(op2String)\(operation)\(op1String)"
          }
          return (expression, op2Remaining)
        case .Constant(let operand, _):
          return ("\(operand)", remainingOps)
        }
      }
      return ("?", ops)
    }

    var remainingOps = opStack
    var strings = [String]()
    while (!remainingOps.isEmpty) {
      let (result, ops) = stringify(remainingOps)
      strings.insert(result, atIndex: 0)
      remainingOps = ops
    }
    return strings.map { String($0) }.joinWithSeparator(",")
  }

  var history: String {
    get {
      return opStack.map { String($0) }.joinWithSeparator(", ")
    }
  }

  init() {
    func learnOp(op: Op) {
      knownOps[op.description] = op
    }
    
    learnOp(Op.BinaryOperation("×", *))
    learnOp(Op.BinaryOperation("÷") { $1 / $0 })
    learnOp(Op.BinaryOperation("+", +))
    learnOp(Op.BinaryOperation("−") { $1 - $0 })  
    learnOp(Op.UnaryOperation("√", sqrt))
    learnOp(Op.UnaryOperation("sin", sin))
    learnOp(Op.UnaryOperation("cos", cos))
    learnOp(Op.Constant("π", M_PI))
  }

  var program: AnyObject { // guaranteed to be a PropertyList
    get {
      return opStack.map { $0.description }
    }
    set {
      if let opSymbols = newValue as? Array<String> {
        var newOpStack = [Op]()
        for opSymbol in opSymbols {
          if let op = knownOps[opSymbol] {
            newOpStack.append(op)
          } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
            newOpStack.append(.Operand(operand))
          }
        }
        opStack = newOpStack
      }
    }
  }

  private enum Op: CustomStringConvertible {
    case Operand(Double)
    case Variable(String)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
    case Constant(String, Double)
    
    var description: String {
      switch self {
      case .Operand(let operand):
        return String(format: "%g", operand)
      case .Variable(let variable):
        return "\(variable)"
      case .UnaryOperation(let symbol, _):
        return symbol
      case .BinaryOperation(let symbol, _):
        return symbol
      case .Constant(let symbol, _):
        return symbol
      }
    }

    var precedence: Int {
      switch self {
      case .BinaryOperation(let symbol, _):
        if symbol == "×" || symbol == "÷" {
          return 2
        } else {
          return 1
        }
      default:
        return Int.max
      }
    }
  }

  private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
    if !ops.isEmpty {
      var remainingOps = ops
      let op = remainingOps.removeLast()
      
      switch op {
      case .Operand(let operand):
        return (operand, remainingOps)
      case .Variable(let operand):
        return (variableValues[operand], remainingOps)
      case .UnaryOperation(_, let operation):
        let operandEvaluation = evaluate(remainingOps)
        if let operand = operandEvaluation.result {
          return (operation(operand), operandEvaluation.remainingOps)
        }
      case .BinaryOperation(_, let operation):
        let op1Evaluation = evaluate(remainingOps)
        if let operand1 = op1Evaluation.result {
          let op2Evaluation = evaluate(op1Evaluation.remainingOps)
          if let operand2 = op2Evaluation.result {
            return (operation(operand1, operand2), op2Evaluation.remainingOps)
          }
        }
      case .Constant(_, let operand):
        return (operand, remainingOps)
      }
    }
    return (nil, ops)
  }

  // Evaluate stack and return result
  func evaluate() -> Double? {
    return evaluate(opStack).result
  }
  
  func pushOperand(operand: Double) -> Double? {
    opStack.append(Op.Operand(operand))
    return evaluate()
  }

  func pushOperand(symbol: String) -> Double? {
    opStack.append(Op.Variable(symbol))
    return evaluate()
  }
  
  func pushConstant(symbol: String) -> Double? {
    if let constant = knownOps[symbol] {
      opStack.append(constant)
    }
    return evaluate()
  }
  
  func performOperation(symbol: String) -> Double? {
    if let operation = knownOps[symbol] {
      opStack.append(operation)
    }
    return evaluate()
  }
  
  func clearStack() {
    opStack.removeAll()
  }
}