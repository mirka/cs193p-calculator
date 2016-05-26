//
//  GraphView.swift
//  Calculator
//
//  Created by Lena on 5/26/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import UIKit

class GraphView: UIView {
  var origin: CGPoint?
  var scale: CGFloat = 1

  override func drawRect(rect: CGRect) {
    if origin == nil {
      origin = center
    }
    let axes = AxesDrawer(color: UIColor.darkGrayColor())
    axes.drawAxesInRect(rect, origin: origin!, pointsPerUnit: 50)
  }
}