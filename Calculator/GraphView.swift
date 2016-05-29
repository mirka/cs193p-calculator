//
//  GraphView.swift
//  Calculator
//
//  Created by Lena on 5/26/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
  var program: AnyObject? { get set }
  func calculateYfor(x: Double) -> Double?
}

@IBDesignable class GraphView: UIView {
  
  @IBInspectable var origin: CGPoint? { didSet { setNeedsDisplay() } }
  @IBInspectable var scale: CGFloat = 10 { didSet { setNeedsDisplay() } }

  weak var dataSource: GraphViewDataSource?

  override func drawRect(rect: CGRect) {
    var path: UIBezierPath?

    if origin == nil {
      origin = center
    }

    let axes = AxesDrawer(color: UIColor.darkGrayColor(), contentScaleFactor: contentScaleFactor)
    axes.drawAxesInRect(rect, origin: origin!, pointsPerUnit: scale)

    path = makeGraphPath()
    UIColor.blueColor().setStroke()
    path?.stroke()
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

  private func makeGraphPath() -> UIBezierPath {
    let path = UIBezierPath()
    var previousEvaluationWasValid = false

    for x in Int(bounds.minX)...Int(bounds.maxX) {
      let visualX = CGFloat(x)
      let actualX = Double((visualX - round(origin!.x)) / scale)
      if let actualY = dataSource?.calculateYfor(actualX) where (actualY.isNormal || actualY.isZero) {
        let visualY: CGFloat = round(origin!.y) - (CGFloat(actualY) * scale)
        let thisPoint = CGPointMake(visualX, visualY)
        previousEvaluationWasValid ? path.addLineToPoint(thisPoint) : path.moveToPoint(thisPoint)
        previousEvaluationWasValid = true
      } else {
        previousEvaluationWasValid = false
      }
    }
    return path
  }

}