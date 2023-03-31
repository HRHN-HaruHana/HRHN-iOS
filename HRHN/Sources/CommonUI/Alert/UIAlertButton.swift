//
//  UIAlertButton.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/07.
//

import UIKit

final class UIAlertButton: UIButton {
    
    var title = "" {
        didSet {
            var titleAttribute = AttributedString(title)
            titleAttribute.font = .systemFont(ofSize: 18, weight: .bold)
            configuration?.attributedTitle = titleAttribute
        }
    }
    
    var baseForegroundColor: UIColor = .label {
        didSet {
            configuration?.baseForegroundColor = baseForegroundColor
        }
    }
    
    var baseBackgroundColor: UIColor = .cellFill {
        didSet {
            configuration?.baseBackgroundColor = baseBackgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        var titleAttribute = AttributedString("취소")
        titleAttribute.font = .systemFont(ofSize: 18, weight: .bold)
        
        configuration = UIButton.Configuration.filled()
        configuration?.attributedTitle = titleAttribute
        configuration?.baseForegroundColor = baseForegroundColor
        configuration?.baseBackgroundColor = baseBackgroundColor
        configuration?.cornerStyle = .fixed
        configuration?.background.cornerRadius = 16
    }
}
