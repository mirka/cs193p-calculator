//
//  GraphView.swift
//  Calculator
//
//  Created by Lena on 5/26/16.
//  Copyright © 2016 Lena. All rights reserved.
//

import UIKit

class GraphView: UIView {

  override func drawRect(rect: CGRect) {
    let axes = AxesDrawer(color: UIColor.darkGrayColor())
    axes.drawAxesInRect(rect, origin: self.center, pointsPerUnit: 100)
  }
}