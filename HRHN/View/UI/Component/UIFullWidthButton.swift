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
    
    var isDisabled: Bool = false {
        didSet {
            setDisabled()
        }
    }
    
    var withKeyboard: Bool = false {
        didSet {
            setCornerRadius()
        }
    }
    
    var action: UIAction = UIAction(handler: { _ in }) {
        didSet {
            addAction(action, for: .touchUpInside)
        }
    }
    
    private let enabledFillColor: UIColor = .point!
    private let disabledFillColor: UIColor = .disabled!
    private let labelColor: UIColor = .reverseLabel
    
    // MARK: Life Cycle
    
    convenience init() {
        self.init(configuration: .filled())

        setUI()
        setLayout()
    }
}

// MARK: Methods

private extension UIFullWidthButton {
    
    func setLabel() {
        var titleAttribute = AttributedString(title)
        titleAttribute.font = .systemFont(ofSize: 14)
        configuration?.attributedTitle = titleAttribute
    }
    
    func setDisabled() {
        isUserInteractionEnabled = !isDisabled
        if isDisabled {
            configuration?.baseBackgroundColor = disabledFillColor
        } else {
            configuration?.baseBackgroundColor = enabledFillColor
        }
    }
    
    func setCornerRadius() {
        if withKeyboard {
            configuration?.cornerStyle = .fixed
            configuration?.background.cornerRadius = 0
        } else {
            configuration?.cornerStyle = .capsule
        }
    }
    
    func setUI() {
        configuration?.baseBackgroundColor = enabledFillColor
        configuration?.baseForegroundColor = labelColor
        configuration?.cornerStyle = .capsule
    }
    
    func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
}
