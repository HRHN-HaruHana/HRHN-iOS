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
    
    static let background = appearanceColor(light: .pureWhite, dark: .gray04)
    
    static let navigationBarButton = appearanceColor(light: .hierarchyLight, dark: .hierarchyDark).withAlphaComponent(0.4)
    
    static let whiteLabel = resolvedColor(.pureWhite)
    static let reverseLabel = appearanceColor(light: .pureWhite, dark: .pureBlack)
    
    static let disabled = appearanceColor(light: .grayEF, dark: .gray1D)
    static let disabledLabel = appearanceColor(light: .grayB9, dark: .gray59)
    static let dim = appearanceColor(light: .gray54, dark: .grayD0)
    
    static let point = resolvedColor(.red01)
    
    static let cellFill = appearanceColor(light: .grayFB, dark: .gray22)
    static let cellLabel = appearanceColor(light: .gray10, dark: .grayD4)
    static let settingIconFill = resolvedColor(.grayC5)
    
    static let nonEmojiDay = appearanceColor(light: .hierarchyLight, dark: .hierarchyDark).withAlphaComponent(0.3)
    static let nonEmojiDaySelected = appearanceColor(light: .hierarchyDark, dark: .hierarchyLight).withAlphaComponent(0.3)
    static let selectedReviewBackground = resolvedColor(.gray54)
    
    static let ellipsisButtonBackground = appearanceColor(light: .grayF4, dark: .gray4A)
    static let sheetBackground = appearanceColor(light: .pureWhite, dark: .gray14)
    static let toastMessageBackground = appearanceColor(light: .pureWhite, dark: .gray22)
}
