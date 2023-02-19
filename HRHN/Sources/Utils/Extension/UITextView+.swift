//
//  UITextView+.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/28.
//

import UIKit

extension UITextView {
    func centerVertically() {
            let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
            let size = sizeThatFits(fittingSize)
            let topOffset = (bounds.size.height - size.height * zoomScale) / 2
            let positiveTopOffset = max(1, topOffset)
            contentOffset.y = -positiveTopOffset
     }
}
