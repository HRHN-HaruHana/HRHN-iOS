//
//  UIColor+.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/21.
//

import UIKit

extension UIColor {
    static func resolvedColor(_ color: CustomColor) -> UIColor? {
        return UIColor(named: color.rawValue)!
    }
    
    static func appearanceColor(light: CustomColor, dark: CustomColor) -> UIColor {
        UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return resolvedColor(light)!
            case .dark:
                return resolvedColor(dark)!
            @unknown default:
                return resolvedColor(light)!
            }
        }
    }
}

// MARK: - Semantic Colors

extension UIColor {
    
    static let background = resolvedColor(.white)
    
    static let reverseLabel = appearanceColor(light: .white, dark: .black)
    
    static let disabled = resolvedColor(.grayD4)
    static let dim = resolvedColor(.gray54)
    
    static let point = resolvedColor(.red02)
    
    static let challengeCardFill = resolvedColor(.grayFB)
    static let challengeCardLabel = resolvedColor(.gray4A)
    static let challngeListFill = resolvedColor(.grayF6)
    static let challengeListLabel = resolvedColor(.gray81)
    static let settingIconFill = resolvedColor(.grayC5)
    
    static let emojiRed = resolvedColor(.red01)
    static let emojiYellow = resolvedColor(.yellow01)
    static let emojiGreen = resolvedColor(.green01)
    static let emojiSkyblue = resolvedColor(.skyblue01)
    static let emojiBlue = resolvedColor(.blue01)
    static let emojiPurple = resolvedColor(.purple01)
}

