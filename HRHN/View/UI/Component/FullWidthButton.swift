//
//  FullWidthButton.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/25.
//

import UIKit
import SnapKit

final class FullWidthButton: UIButton {
    
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

private extension FullWidthButton {
    
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

// MARK: - Preview

#if DEBUG
import SwiftUI

struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

struct FriendCellPreviews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let button = FullWidthButton()
            button.title = "다음"
            button.isDisabled = true
            button.withKeyboard = true
            return button
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
