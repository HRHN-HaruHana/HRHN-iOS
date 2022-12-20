//
//  Double+.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/21.
//

import UIKit

extension Double {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 390
        return CGFloat(self) * ratio
    }
}

