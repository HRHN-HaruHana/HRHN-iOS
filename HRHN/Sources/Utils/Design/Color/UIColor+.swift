//
//  UIColor+.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/21.
//

import UIKit

extension UIColor {
    static func resolvedColor(_ color: CustomColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
    
    static func appearanceColor(light: CustomColor, dark: CustomColor) -> UIColor {
        UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return resolvedColor(light)
            case .dark:
                return resolvedColor(dark)
            @unknown default:
                return resolvedColor(light)
            }
        }
    }
}

// MARK: - Semantic Colors

extension UIColor {
    
    static let background = appearanceColor(light: .white, dark: .gray14)
    
    static let whiteLabel = resolvedColor(.white)
    static let reverseLabel = appearanceColor(light: .white, dark: .black)
    
    static let disabled = appearanceColor(light: .grayEF, dark: .gray1D)
    static let disabledLabel = appearanceColor(light: .grayB9, dark: .gray59)
    static let dim = appearanceColor(light: .gray54, dark: .grayD0)
    
    static let point = resolvedColor(.red01)
    
    static let cellFill = appearanceColor(light: .grayFB, dark: .gray22)
    static let cellLabel = appearanceColor(light: .gray4A, dark: .grayD4)
    static let settingIconFill = resolvedColor(.grayC5)
}
