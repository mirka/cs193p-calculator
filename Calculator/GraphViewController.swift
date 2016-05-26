//
//  GraphViewController.swift
//  Calculator
//
//  Created by Lena on 5/26/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

  @IBOutlet weak var graph: GraphView! {
    didSet {
      graph.addGestureRecognizer(UIPanGestureRecognizer(target: graph, action: #selector(GraphView.panGraph)))
    }
  }

  private func updateUI() {
    graph.setNeedsDisplay()
  }
}