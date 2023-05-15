//
//  UIReviewView.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/09.
//

import Combine
import UIKit

final class ReviewView: UIView {
    
    // MARK: - Properties
    
    var viewModel: ReviewViewModel!
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private lazy var titleLable: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        switch viewModel.previousTab {
        case .today:
            $0.text = I18N.emojiTitleAdd
        case .list:
            $0.text = I18N.emojiTitleRecord
        case .calendar:
            $0.text = I18N.emojiTitleRecord
        default:
            break
        }
        return $0
    }(UILabel())
    
    private let challengeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .cellLabel
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var successButton: UIEmojiButton = {
        $0.action = UIAction { _ in
            self.viewModel.selectedEmoji = .success
            self.viewModel.didEmojiClicked()
        }
        return $0
    }(UIEmojiButton(emoji: .success))
    
    private lazy var triedButton: UIEmojiButton = {
        $0.action = UIAction { _ in
            self.viewModel.selectedEmoji = .tried
            self.viewModel.didEmojiClicked()
        }
        return $0
    }(UIEmojiButton(emoji: .tried))
    
    private lazy var failButton: UIEmojiButton = {
        $0.action = UIAction { _ in
            self.viewModel.selectedEmoji = .fail
            self.viewModel.didEmojiClicked()
        }
        return $0
    }(UIEmojiButton(emoji: .fail))
    
    private let contentsStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = .zero
        $0.alignment = .leading
        return $0
    }(UIStackView())
    
    private let buttonsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private lazy var contextMenuButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 13, weight: .medium)
        )
        $0.setImage(UIImage(systemName: "ellipsis", withConfiguration: imageConfig), for: .normal)
        
        $0.configuration?.baseBackgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        $0.configuration?.baseForegroundColor = .cellLabel
        $0.configuration?.cornerStyle = .capsule
        
        let storageAction = UIAction(
            title: "내용 수정",
            image: UIImage(systemName: "pencil")
        ) { _ in
            // TODO: connect storage view
        }
        let deleteAction = UIAction(
            title: "삭제",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { _ in
            // TODO: Delete Challenge
        }
        let menu = UIMenu(children: [storageAction, deleteAction])
        $0.menu = menu
        $0.showsMenuAsPrimaryAction = true
        return $0
    }(UIButton(configuration: .filled()))
    
    // MARK: - Life Cycle

    init(viewModel: ReviewViewModel) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        setLayout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - bind
    
    func bind() {
        viewModel.$challenge
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.challengeLabel.text = $0?.content
            }
            .store(in: &cancelBag)
        
        viewModel.$selectedEmoji
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                switch $0 {
                case .success:
                    self?.successButton.isSelected = true
                    self?.triedButton.isSelected = false
                    self?.failButton.isSelected = false
                case .tried:
                    self?.successButton.isSelected = false
                    self?.triedButton.isSelected = true
                    self?.failButton.isSelected = false
                case .fail:
                    self?.successButton.isSelected = false
                    self?.triedButton.isSelected = false
                    self?.failButton.isSelected = true
                default:
                    self?.successButton.isSelected = false
                    self?.triedButton.isSelected = false
                    self?.failButton.isSelected = false
                }
            }
            .store(in: &cancelBag)
        
        viewModel.emojiDidTap
            .sink { [weak self] in
                guard let bottomSheetVC = self?.superview?.superview?.superview?.next as? BottomSheetController else { return }
                bottomSheetVC.dismissBottomSheet()
                bottomSheetVC.emojiTap()
            }
            .store(in: &cancelBag)
    }
    
    // MARK: - Functions
    
    private func setLayout() {
        addSubviews(
            contentsStackView
        )
        
        contentsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentsStackView.addArrangedSubviews(
            titleLable,
            challengeLabel,
            buttonsStackView
        )

        challengeLabel.snp.makeConstraints {
            $0.height.equalTo(136.verticallyAdjusted)
            $0.width.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(challengeLabel.snp.bottom)
            $0.bottom.equalToSuperview()
        }

        buttonsStackView.addArrangedSubviews(
            successButton,
            triedButton,
            failButton
        )
        
        if viewModel.previousTab == .calendar {
            addSubview(contextMenuButton)
            contextMenuButton.snp.makeConstraints {
                $0.width.height.equalTo(26)
                $0.trailing.equalToSuperview()
                $0.centerY.equalTo(titleLable)
            }
        }
    }
}
