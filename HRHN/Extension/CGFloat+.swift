//
//  CGFloat.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/21.
//
//  ref: https://github.com/hanulyun/Autolayout-iPhone

import UIKit

extension CGFloat {
    var horizontallyAdjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 390
        return self * ratio
    }
    
    var verticallyAdjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 844
        return self * ratio
    }
}
