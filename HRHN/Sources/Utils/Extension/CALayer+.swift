//
//  CALayer+.swift
//  HRHN
//
//  Created by 민채호 on 2023/05/18.
//

import Foundation

import UIKit

extension CALayer {
  func applyFigmaShadow(
    color: UIColor = .black,
    opacity: Float = 0.1,
    xCoord: CGFloat = 0,
    yCoord: CGFloat = 0,
    blur: CGFloat = 40,
    spread: CGFloat = 0) {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = opacity
    shadowOffset = CGSize(width: xCoord, height: yCoord)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dxCoord = -spread
      let rect = bounds.insetBy(dx: dxCoord, dy: dxCoord)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
