//
//  GraphViewController.swift
//  Calculator
//
//  Created by Lena on 5/26/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
  private let calculatorBrain = CalculatorBrain()
  var program: AnyObject? {
    didSet {
      calculatorBrain.program = program!
      let brainString = calculatorBrain.description
      let lastExpression = brainString.characters.split(",").last
      graphDescription.title = lastExpression.map(String.init)
    }
  }

  @IBOutlet weak var graph: GraphView! {
    didSet {
      graph.dataSource = self
      graph.addGestureRecognizer(UIPanGestureRecognizer(target: graph, action: #selector(GraphView.panGraph)))
      graph.addGestureRecognizer(UIPinchGestureRecognizer(target: graph, action: #selector(GraphView.scaleGraph)))
    }
  }

  @IBOutlet weak var graphDescription: UINavigationItem!

  @IBAction func setOrigin(tap: UITapGestureRecognizer) {
    graph.setOrigin(tap)
  }

  func calculateYfor(x: Double) -> Double? {
    calculatorBrain.variableValues["M"] = x
    return calculatorBrain.evaluate()
  }
}