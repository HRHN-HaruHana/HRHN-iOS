//
//  CGFloat.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/21.
//
//  ref: https://github.com/hanulyun/Autolayout-iPhone

import UIKit

extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 390
        return self * ratio
    }
}
