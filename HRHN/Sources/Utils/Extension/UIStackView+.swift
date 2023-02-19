//
//  UIStackView+.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/20.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ subviews: UIView...) {
    for subview in subviews {
      addArrangedSubview(subview)
    }
  }
}
