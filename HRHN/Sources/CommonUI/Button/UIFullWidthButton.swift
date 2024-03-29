//
//  UIFullWidthButton.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/25.
//

import UIKit
import SnapKit

final class UIFullWidthButton: UIButton {
    
    // MARK: Properties
    
    var title: String = "" {
        didSet {
            setLabel()
        }
    }
    
    var isOnKeyboard: Bool = false {
        didSet {
            setCornerRadius()
        }
    }
    
    var action: UIAction = UIAction(handler: { _ in }) {
        didSet {
            addAction(action, for: .touchUpInside)
        }
    }
    
    // MARK: Life Cycle
    
    convenience init() {
        self.init(configuration: .filled())

        setUI()
        setLayout()
    }
}

// MARK: Methods

extension UIFullWidthButton {
    
    private func setLabel() {
        var titleAttribute = AttributedString(title)
        titleAttribute.font = .systemFont(ofSize: 14)
        configuration?.attributedTitle = titleAttribute
    }
    
    private func setCornerRadius() {
        if isOnKeyboard {
            configuration?.cornerStyle = .fixed
            configuration?.background.cornerRadius = 0
        } else {
            configuration?.cornerStyle = .capsule
        }
    }
    
    private func setUI() {
        configuration?.baseBackgroundColor = .point
        configuration?.baseForegroundColor = .whiteLabel
        configuration?.cornerStyle = .capsule
    }
    
    private func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
}
