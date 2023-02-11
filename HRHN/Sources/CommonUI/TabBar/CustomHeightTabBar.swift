//
//  CustomHeightTabBar.swift
//  HRHN
//
//  Created by 민채호 on 2023/02/11.
//
// https://stackoverflow.com/questions/48192749/hidesbottombarwhenpushed-makes-uitabbar-jump
// https://gist.github.com/calt/7ea29a65b440c2aa8a1a

import UIKit

class CustomHeightTabBar : UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 99
        return sizeThatFits
    }
}
