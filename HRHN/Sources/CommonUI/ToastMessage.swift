//
//  ToastMessage.swift
//  HRHN
//
//  Created by 민채호 on 2023/05/16.
//

import UIKit

final class ToastMessage: UIButton {
    
    private let isButton: Bool
    
    private let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15, weight: .medium),
    ]
    
    private let subtitleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 12, weight: .medium),
        .foregroundColor: UIColor.secondaryLabel,
    ]
    
    init(
        isButton: Bool = false,
        title: String,
        subtitle: String? = nil,
        subtitleSymbol: UIImage? = nil
    ) {
        self.isButton = isButton
        super.init(frame: .zero)
        
        configuration = Configuration.filled()
        setTitles(title: title, subtitle: subtitle, subtitleSymbol: subtitleSymbol)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToastMessage {
    
    private func setTitles(title: String, subtitle: String?, subtitleSymbol: UIImage?) {
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        attributedTitle.foregroundColor = .label
        configuration?.attributedTitle = attributedTitle
        
        if let subtitle = subtitle, let subtitleSymbol = subtitleSymbol {
            let symbolAttachment = NSTextAttachment()
            symbolAttachment.image = subtitleSymbol.withTintColor(.secondaryLabel)
            symbolAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            
            let whiteSpaceAttachment = NSTextAttachment()
            whiteSpaceAttachment.image = UIImage()
            whiteSpaceAttachment.bounds = CGRect(x: 0, y: 0, width: 2, height: 0)
            
            let mutableAttrString = NSMutableAttributedString()
            mutableAttrString.append(NSAttributedString(attachment: symbolAttachment))
            mutableAttrString.append(NSAttributedString(attachment: whiteSpaceAttachment))
            mutableAttrString.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
            
            let attributedString = AttributedString(mutableAttrString)
            configuration?.attributedSubtitle = attributedString
        } else if let subtitle {
            var attributedSubtitle = AttributedString(subtitle)
            attributedSubtitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            attributedSubtitle.foregroundColor = .secondaryLabel
            configuration?.attributedSubtitle = attributedSubtitle
        }
        
        configuration?.titleAlignment = .center
        configuration?.titlePadding = 2
    }
    
    private func setUI() {
        isUserInteractionEnabled = isButton
        layer.applyFigmaShadow()
        
        configuration?.baseBackgroundColor = .background
        configuration?.cornerStyle = .capsule
        configuration?.contentInsets = .init(top: 0, leading: 25, bottom: 0, trailing: 25)
    }
    
    private func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(55)
        }
    }
}
