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
    
    init(isButton: Bool = false, title: String, subtitle: String? = nil) {
        self.isButton = isButton
        super.init(frame: .zero)
        
        configuration = Configuration.filled()
        setTitles(title: title, subtitle: subtitle)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToastMessage {
    
    private func setTitles(title: String, subtitle: String?) {
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        attributedTitle.foregroundColor = .label
        configuration?.attributedTitle = attributedTitle
        
        if let subtitle {
            var attributedSubtitle = AttributedString(subtitle)
            attributedSubtitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            attributedSubtitle.foregroundColor = .secondaryLabel
            configuration?.attributedSubtitle = attributedSubtitle
        }
        
        configuration?.titleAlignment = .center
        configuration?.titlePadding = 2
    }
    
    private func setUI() {
//        isUserInteractionEnabled = isButton
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

//final class ToastMessage: UIButton {
//
//    private let isButton: Bool
//
//    private let title: UILabel = {
//        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        $0.textAlignment = .center
//        return $0
//    }(UILabel())
//
//    private let subtitle: UILabel = {
//        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        $0.textColor = .secondaryLabel
//        $0.textAlignment = .center
//        return $0
//    }(UILabel())
//
//    private let titleStack: UIStackView = {
//        $0.axis = .vertical
//        $0.spacing = 2
//        $0.alignment = .center
//        return $0
//    }(UIStackView())
//
//    init(isButton: Bool = false, title: String, subtitle: String? = nil) {
//        self.isButton = isButton
//        self.title.text = title
//        self.subtitle.text = subtitle
//        super.init(configuration: .filled())
//
//        setLayout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension ToastMessage {
//
//    private func setUI() {
//        isUserInteractionEnabled = isButton
//
//        configuration?.cornerStyle = .capsule
//        backgroundColor = .background
//
//    }
//
//    private func setLayout() {
//
//        addSubview(titleStack)
//
//        titleStack.addArrangedSubviews(
//            title,
//            subtitle
//        )
//    }
//}
