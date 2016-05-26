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

  func panGraph(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .Ended: fallthrough
    case .Changed:
      let translation = gesture.translationInView(self)
      origin = CGPointMake(origin!.x + translation.x, origin!.y + translation.y)
      gesture.setTranslation(CGPointZero, inView: self)
    default: break
    }
  }
  
  func scaleGraph(gesture: UIPinchGestureRecognizer) {
    if gesture.state == .Changed {
      scale *= gesture.scale
      gesture.scale = 1
    }
  }

  func setOrigin(tap: UITapGestureRecognizer) {
    origin = tap.locationInView(self)
  }
}