//
//  EditView.swift
//  HRHN
//
//  Created by 민채호 on 2023/05/30.
//

import Combine
import UIKit

final class EditView: UIView {
    
    // MARK: - Properties
    
    var viewModel: EditViewModel!
    var handler: EditViewHandler!
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Edit Challenge
    
    private let mainTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 26, weight: .bold),
        .foregroundColor: UIColor.cellLabel,
    ]
    
    private let placeholderTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 26, weight: .bold),
        .foregroundColor: UIColor.cellLabel.withAlphaComponent(0.3),
    ]
    
    private let lengthTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15, weight: .bold),
        .foregroundColor: UIColor.cellLabel,
    ]
    
    lazy var challengeTextView: UITextView = {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: mainTextAttributes
        )
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        $0.autocapitalizationType = .sentences
        $0.autocorrectionType = .no
        $0.textContainerInset = .zero
        $0.contentInset = .zero
        $0.scrollIndicatorInsets = .zero
        $0.isScrollEnabled = false
        $0.centerVertically()
        $0.tintColor = .clear
        $0.returnKeyType = .done
        $0.enablesReturnKeyAutomatically = true
        $0.delegate = self
        return $0
    }(UITextView())
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return $0
    }(UILabel())
    
    private let challengeView = UIView()
    
    private lazy var placeholderLabel: UILabel = {
        $0.attributedText = NSAttributedString(
            string: "챌린지를 작성하세요",
            attributes: mainTextAttributes
        )
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.layer.opacity = 0.3
        return $0
    }(UILabel())
    
    private lazy var cancelButton: UIButton = {
        let title: String = "취소"
        let image: String = "xmark"
        
        var titleAttribute = AttributedString(title)
        titleAttribute.font = .systemFont(ofSize: 16, weight: .medium)
        $0.configuration?.attributedTitle = titleAttribute
        
        let imageConfig = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 13, weight: .medium)
        )
        $0.setImage(UIImage(systemName: image, withConfiguration: imageConfig), for: .normal)
        $0.configuration?.imagePadding = 4
        
        $0.configuration?.baseForegroundColor = .label
        $0.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        $0.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        return $0
    }(UIButton(configuration: .plain()))
    
    private lazy var saveButton: UIButton = {
        let title: String = "예약"
        let image: String = "checkmark"
        
        var titleAttribute = AttributedString(title)
        titleAttribute.font = .systemFont(ofSize: 16, weight: .medium)
        $0.configuration?.attributedTitle = titleAttribute
        
        let imageConfig = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 13, weight: .medium)
        )
        $0.setImage(UIImage(systemName: image, withConfiguration: imageConfig), for: .normal)
        $0.configuration?.imagePadding = 4
        
        $0.configuration?.baseForegroundColor = .label
        $0.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        $0.isEnabled = false
        
        $0.addTarget(self, action: #selector(reserveChallengeAndDismissSheet), for: .touchUpInside)
        return $0
    }(UIButton(configuration: .plain()))
    
    private lazy var contextMenuButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 13, weight: .medium)
        )
        $0.setImage(UIImage(systemName: "ellipsis", withConfiguration: imageConfig), for: .normal)
        
        $0.configuration?.baseBackgroundColor = .ellipsisButtonBackground
        $0.configuration?.baseForegroundColor = .cellLabel
        $0.configuration?.cornerStyle = .capsule
        
        let deleteAction = UIAction(
            title: "삭제",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { _ in
            self.viewModel.deleteChallenge()
            self.handler.sheetWillDismissSubject.send()
            self.handler.deleteButtonDidTapSubject.send()
        }
        let menu = UIMenu(children: [deleteAction])
        $0.menu = menu
        $0.showsMenuAsPrimaryAction = true
        return $0
    }(UIButton(configuration: .filled()))
    
    private let contentsStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = .zero
        $0.alignment = .leading
        return $0
    }(UIStackView())
    
    private let buttonsView = UIView()
    
    // MARK: Life Cycles
    
    init(viewModel: EditViewModel, handler: EditViewHandler) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        self.handler = handler
        challengeTextView.text = .none
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.$selectedChallenge
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedChallenge in
                if selectedChallenge == nil {
                    self?.setReserveMode()
                } else {
                    self?.setEditMode()
                }
            }
            .store(in: &cancelBag)
        handler.sheetWillPresentSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.challengeTextView.becomeFirstResponder()
                self?.checkTextLength(textView: self?.challengeTextView)
                if self?.viewModel.selectedChallenge != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self?.challengeTextView.tintColor = .tintColor
                        self?.challengeTextView.selectAll(nil)
                    }
                }
            }
            .store(in: &cancelBag)
        handler.sheetWillDismissSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.challengeTextView.resignFirstResponder()
                self?.challengeTextView.text = .none
            }
            .store(in: &cancelBag)
    }
}

extension EditView {
    
    private func setLayout() {
        addSubviews(
            contentsStackView
        )
        
        contentsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentsStackView.addArrangedSubviews(
            titleLabel,
            challengeView,
            buttonsView
        )
        
        buttonsView.addSubviews(
            cancelButton,
            saveButton
        )
        
        buttonsView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(cancelButton.snp.height)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        challengeView.snp.makeConstraints {
            $0.height.equalTo(136.verticallyAdjusted)
            $0.width.equalToSuperview()
        }
        
        challengeView.addSubviews(
            challengeTextView,
            placeholderLabel
        )
        
        challengeTextView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentsStackView.addSubview(contextMenuButton)
        contextMenuButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func setReserveMode() {
        guard let selectedDate = viewModel.selectedDate else { return }
        titleLabel.text = getDescription(of: selectedDate)
        challengeTextView.text = .none
        
        placeholderLabel.isHidden = false
        contextMenuButton.isHidden = true
    }
    
    private func setEditMode() {
        guard let selectedDate = viewModel.selectedDate else { return }
        if selectedDate.isToday() {
            titleLabel.text = "오늘 챌린지 수정"
        } else if selectedDate.isFuture() {
            titleLabel.text = getDescription(of: selectedDate)
        } else if selectedDate.isPast() {
            titleLabel.text = "\(selectedDate.month)/\(selectedDate.day) 챌린지 수정"
            
            var titleAttribute = AttributedString("수정")
            titleAttribute.font = .systemFont(ofSize: 16, weight: .medium)
            saveButton.configuration?.attributedTitle = titleAttribute
        }
        challengeTextView.text = viewModel.selectedChallenge?.content
        
        placeholderLabel.isHidden = true
        contextMenuButton.isHidden = false
    }
}

extension EditView {
    
    @objc private func cancelButtonDidTap() {
        handler.sheetWillDismissSubject.send()
    }
    
    private func dayDifferenceBetweenToday(and date: Date) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let components = calendar.dateComponents([.day], from: today, to: date)
        return components.day ?? 0
    }
    
    private func getDescription(of date: Date) -> String {
        let today = Date()
        let dayDifference = dayDifferenceBetweenToday(and: date)
        let weekDifference = Int((dayDifference+(today.weekdayNumber()-1))/7)
        let footerWithoutDayName = " (\(date.month)/\(date.day))"
        let footerWithDayName = " (\(date.month)/\(date.day), \(date.dayName))"
        
        switch weekDifference {
        case 0:
            switch dayDifference {
            case 1:
                return "내일" + footerWithDayName
            case 2:
                return "내일 모레" + footerWithDayName
            default:
                return "이번 주 \(date.dayName)" + footerWithoutDayName
            }
        case 1:
            return "다음 주 \(date.dayName)" + footerWithoutDayName
        default:
            return "\(weekDifference)주 후 \(date.dayName)" + footerWithoutDayName
        }
    }
}

// MARK: - UITextViewDelegate

extension EditView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        deleteOverFlowedTexts(textView: textView)
        checkTextLength(textView: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText input: String) -> Bool {
        let returnButton = "\n"
        let isTextExist = !textView.text.isEmpty
        
        if input == returnButton && isTextExist {
            reserveChallengeAndDismissSheet()
            return false
        } else {
            return true
        }
    }
}

extension EditView {
    private func checkTextLength(textView: UITextView?) {
        guard let textView else { return }
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
            textView.tintColor = .clear
            saveButton.isEnabled = false
        } else {
            placeholderLabel.isHidden = true
            textView.tintColor = .tintColor
            saveButton.isEnabled = true
        }
    }
    
    private func deleteOverFlowedTexts(textView: UITextView) {
        let maxTextLength = 50
        if textView.text.count > maxTextLength {
            let overflowRange = textView.text.index(textView.text.startIndex, offsetBy: 50)...
            textView.text.removeSubrange(overflowRange)
        }
    }
    
    @objc private func reserveChallengeAndDismissSheet() {
        viewModel.reserveChallenge(challengeTextView.text)
        handler.sheetWillDismissSubject.send()
    }
}
