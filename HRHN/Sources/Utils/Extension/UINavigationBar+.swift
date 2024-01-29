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
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = UIBlurEffect(style: .prominent)
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        Self.appearance().standardAppearance = appearance
        Self.appearance().scrollEdgeAppearance = appearance
    }
}
