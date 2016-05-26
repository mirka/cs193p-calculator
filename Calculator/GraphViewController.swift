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
    }
  }

  @IBAction func panGraph(sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .Ended: fallthrough
    case .Changed:
      let translation = sender.translationInView(view)
      let newOrigin = CGPointMake(graph.origin!.x + translation.x, graph.origin!.y + translation.y)
      graph.origin = newOrigin
      updateUI()
      sender.setTranslation(CGPointZero, inView: view)
    default: break
    }
  }

  private func updateUI() {
    graph.setNeedsDisplay()
  }
}