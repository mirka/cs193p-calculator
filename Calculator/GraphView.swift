//
//  GraphView.swift
//  Calculator
//
//  Created by Lena on 5/26/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import UIKit

class GraphView: UIView {
  @IBInspectable var origin: CGPoint? { didSet { setNeedsDisplay() } }
  @IBInspectable var scale: CGFloat = 50 { didSet { setNeedsDisplay() } }

  override func drawRect(rect: CGRect) {
    if origin == nil {
      origin = center
    }
    let axes = AxesDrawer(color: UIColor.darkGrayColor())
    axes.drawAxesInRect(rect, origin: origin!, pointsPerUnit: scale)
  }

  func panGraph(sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .Ended: fallthrough
    case .Changed:
      let translation = sender.translationInView(self)
      origin = CGPointMake(origin!.x + translation.x, origin!.y + translation.y)
      sender.setTranslation(CGPointZero, inView: self)
    default: break
    }
  }
  
  func scaleGraph(sender: UIPinchGestureRecognizer) {
    if sender.state == .Changed {
      scale *= sender.scale
      sender.scale = 1
    }
  }
}