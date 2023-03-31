//
//  UIEmojiButton.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/09.
//

import UIKit
import SnapKit

final class UIEmojiButton: UIButton {
    
    // MARK: - Properties
    
    private var emoji: Emoji = .none
    
    var action: UIAction = UIAction { _ in } {
        didSet {
            self.addAction(action, for: .touchUpInside)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                backgroundColor = .dim
                emojiLabel.textColor = .whiteLabel
            case false:
                backgroundColor = .clear
                emojiLabel.textColor = .cellLabel
            }
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var emojiImageView = UIImageView(image: UIImage(named: emoji.rawValue))
    
    private lazy var emojiLabel: UILabel = {
        switch emoji {
        case .success:
            $0.text = I18N.challengeSuccess
        case .tried:
            $0.text = I18N.challengeTried
        case .fail:
            $0.text = I18N.challengeFail
        default:
            $0.text = "none"
        }
        $0.textColor = .cellLabel
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return $0
    }(UILabel())
    
    private let dotImageView = UIImageView(image: UIImage(named: Assets.dot))
    
    private let labelStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 2
        $0.alignment = .lastBaseline
        return $0
    }(UIStackView())
    
    private let emojiStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    // MARK: - Life Cycle
    
    init(emoji: Emoji) {
        super.init(frame: .zero)
        self.emoji = emoji
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews {
            let convertedPoint = subview.convert(point, from: self)
            if let hitView = subview.hitTest(convertedPoint, with: event), hitView.isUserInteractionEnabled {
                return self
            }
        }
        
        return super.hitTest(point, with: event)
    }
    
    // MARK: - Functions
    
    private func setUI() {
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(
            emojiStackView
        )
        
        emojiStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
            $0.height.equalTo(emojiStackView.intrinsicContentSize.height)
        }
        
        emojiStackView.addArrangedSubviews(
            emojiImageView,
            labelStackView
        )
        
        emojiImageView.snp.makeConstraints {
            $0.width.height.equalTo(80.verticallyAdjusted)
        }
        
        labelStackView.snp.makeConstraints {
            $0.height.equalTo(emojiLabel.intrinsicContentSize.height)
        }
        
        labelStackView.addArrangedSubviews(
            emojiLabel,
            dotImageView
        )
        
        dotImageView.snp.makeConstraints {
            $0.height.width.equalTo(4)
        }
    }
}
