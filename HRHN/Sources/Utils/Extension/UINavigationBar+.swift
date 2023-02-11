//
//  UINavigationBar+.swift
//  HRHN
//
//  Created by 민채호 on 2023/02/10.
//

import UIKit

extension UINavigationBar {
    static func setCustomNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 0.3)
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        Self.appearance().standardAppearance = appearance
        Self.appearance().scrollEdgeAppearance = appearance
    }
}
