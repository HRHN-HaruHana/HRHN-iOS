//
//  TodayViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//

import Combine
import SwiftUI
import UIKit

import SnapKit

final class TodayViewController: UIViewController {
    
    // MARK: - Combine
    
    private let viewModel: TodayViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - TextAttributes
    
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
    
    // MARK: - TextLength Properties
    
    private let maxTextLength = 50
    
    // TODO: viewModel binding
    private lazy var currentTextLength: Int = viewModel.todayChallenge?.content.count ?? 0 {
        didSet {
            textLengthIndicatorLabel.attributedText = NSAttributedString(
                string: "\(currentTextLength)/\(maxTextLength)",
                attributes: lengthTextAttributes
            )
        }
    }
    
    // MARK: - Base UI Properties
    
    private let titleLabel: UILabel = {
        $0.text = I18N.todayTitle
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    private let challengeLayoutView = UIView()
    
    private lazy var challengeCellView: UIView = {
        $0.backgroundColor = .cellFill
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellDidTap))
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(UIView())
    
    private lazy var addButton: UIButton = { [weak self] in
        var titleAttribute = AttributedString(I18N.btnAdd)
        titleAttribute.font = .systemFont(ofSize: 15)
        $0.configuration?.attributedTitle = titleAttribute
        
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 13))
        $0.setImage(UIImage(systemName: "plus", withConfiguration: imageConfig), for: .normal)
        $0.configuration?.imagePadding = 4
        
        $0.configuration?.baseBackgroundColor = .cellFill
        $0.configuration?.baseForegroundColor = .point
        $0.configuration?.cornerStyle = .fixed
        $0.configuration?.background.cornerRadius = 16
        $0.configuration?.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        $0.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        
        return $0
    }(UIButton(configuration: .filled()))
    
    private lazy var placeholderLabel: UILabel = {
        $0.attributedText = NSAttributedString(
            string: "",
            attributes: mainTextAttributes
        )
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    // MARK: - EditChallenge UI Properties
    
    private lazy var challengeTextView: UITextView = {
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
    
    private lazy var textLengthIndicatorLabel: UILabel = {
        $0.attributedText = NSAttributedString(
            string: "\(currentTextLength)/\(maxTextLength)",
            attributes: lengthTextAttributes
        )
        $0.layer.opacity = 0.7
        return $0
    }(UILabel())
    
    private lazy var cancelEditingChallengeButton: UIButton = {
        var title: String
        var image: String
        
        if viewModel.previousChallenge == nil {
            title = "취소"
            image = "xmark"
        } else {
            title = "이전"
            image = "chevron.backward"
        }
        
        var titleAttribute = AttributedString(title)
        titleAttribute.font = .systemFont(ofSize: 16, weight: .medium)
        $0.configuration?.attributedTitle = titleAttribute
        
        let imageConfig = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 13, weight: .medium)
        )
        $0.setImage(UIImage(systemName: image, withConfiguration: imageConfig), for: .normal)
        $0.configuration?.imagePadding = 4
        
        $0.configuration?.baseBackgroundColor = .cellFill
        $0.configuration?.baseForegroundColor = .label
        $0.configuration?.cornerStyle = .fixed
        $0.configuration?.background.cornerRadius = 16
        $0.configuration?.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        $0.addTarget(self, action: #selector(cancelEditingChallenge), for: .touchUpInside)
        return $0
    }(UIButton(configuration: .filled()))
    
    private lazy var endEditingChallengeButton: UIButton = {
        var title: String = "저장"
        var image: String = "checkmark"
        
        var titleAttribute = AttributedString(title)
        titleAttribute.font = .systemFont(ofSize: 16, weight: .medium)
        $0.configuration?.attributedTitle = titleAttribute
        
        let imageConfig = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 13, weight: .medium)
        )
        $0.setImage(UIImage(systemName: image, withConfiguration: imageConfig), for: .normal)
        $0.configuration?.imagePadding = 4
        
        $0.configuration?.baseBackgroundColor = .cellFill
        $0.configuration?.baseForegroundColor = .label
        $0.configuration?.cornerStyle = .fixed
        $0.configuration?.background.cornerRadius = 16
        $0.configuration?.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        $0.addTarget(self, action: #selector(stopEditingAndSaveChallenge), for: .touchUpInside)
        return $0
    }(UIButton(configuration: .filled()))
    
    private lazy var contextMenuButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 13, weight: .medium)
        )
        $0.setImage(UIImage(systemName: "ellipsis", withConfiguration: imageConfig), for: .normal)
        
        $0.configuration?.baseBackgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        $0.configuration?.baseForegroundColor = .cellLabel
        $0.configuration?.cornerStyle = .capsule
        
        let storageAction = UIAction(
            title: "바구니",
            image: UIImage(systemName: "archivebox")
        ) { _ in
            // TODO: connect storage view
        }
        let deleteAction = UIAction(
            title: "삭제",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { _ in
            self.challengeTextView.resignFirstResponder()
            self.presentAlert()
        }
        let menu = UIMenu(children: [storageAction, deleteAction])
        $0.menu = menu
        $0.showsMenuAsPrimaryAction = true
        
        $0.isHidden = true
        return $0
    }(UIButton(configuration: .filled()))
    
    // MARK: - Alert UI Properties
    
    private lazy var testAlert: AlertController = {
        $0.titleString = "챌린지를 삭제할까요?"
        $0.descriptionString = "오늘의 챌린지가 삭제됩니다."

        $0.cancelTitle = "취소"
        $0.cancelForegroundColor = .label
        $0.cancelBackgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        $0.cancelAction = UIAction { _ in
            self.dismissAlert()
            self.challengeTextView.becomeFirstResponder()
        }

        $0.confirmTitle = "삭제"
        $0.confirmForegroundColor = .whiteLabel
        $0.confirmBackgroundColor = .red
        $0.confirmAction = UIAction { _ in
            self.dismissAlert()
            self.viewModel.deleteTodayChallenge()
            self.viewModel.todayChallenge = self.viewModel.getTodayChallenge()
            self.cancelEditingChallenge()
            self.emptyState()
        }
        
        $0.alertWillDismiss = { [weak self] in
            self?.dismissAlert()
            self?.challengeTextView.becomeFirstResponder()
        }
        return $0
    }(AlertController())
    
    
    // MARK: - Bottom Sheet UI Properties
    
    private lazy var bottomSheet: BottomSheetController = {
        $0.sheetWillDismiss = { [weak self] in
            self?.dismissBottomSheet()
        }
        $0.emojiDidTap = { [weak self] in
            self?.viewModel.previousChallenge = self?.viewModel.getPreviousChallenge()
            self?.addState()
        }
        return $0
    }(BottomSheetController(content: bottomSheetContentView))

    private let bottomSheetContentView = ReviewView(viewModel: ReviewViewModel(from: .today))
    
    // MARK: - Life Cycle
    
    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestNotificationAuthorization()
        viewModel.removeOutdatedNotifications()
        setNavigationBar()
        setLayout()
        if viewModel.todayChallenge == nil {
            emptyState()
        } else {
            existState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.todayChallenge = viewModel.getTodayChallenge()
        viewModel.previousChallenge = viewModel.getPreviousChallenge()
        bind()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if challengeTextView.isFirstResponder {
            cancelEditingChallenge()
        }
    }
}

// MARK: - UI Functions

extension TodayViewController {
    
    private func setLayout() {
        view.addSubviews(
            challengeLayoutView,
            cancelEditingChallengeButton,
            endEditingChallengeButton,
            textLengthIndicatorLabel
        )

        challengeLayoutView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view).inset(40)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        challengeLayoutView.addSubviews(
            titleLabel,
            challengeCellView,
            placeholderLabel,
            addButton,
            challengeTextView,
            contextMenuButton
        )
        
        placeholderLabel.snp.makeConstraints {
            $0.center.equalTo(challengeLayoutView)
            $0.horizontalEdges.equalTo(challengeCellView).inset(20)
        }
        
        challengeTextView.snp.makeConstraints {
            $0.center.equalTo(challengeLayoutView)
            $0.horizontalEdges.equalTo(challengeCellView).inset(20)
        }
        
        challengeCellView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(placeholderLabel).offset(-20)
            $0.bottom.equalTo(placeholderLabel).offset(20)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(challengeCellView.snp.top).offset(-10)
        }
        
        contextMenuButton.snp.makeConstraints {
            $0.width.height.equalTo(26)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }

        addButton.snp.makeConstraints {
            $0.top.equalTo(challengeCellView.snp.bottom).offset(10)
            $0.right.equalTo(challengeCellView)
            $0.height.equalTo(50)
        }
        
        cancelEditingChallengeButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(150)
        }
        
        endEditingChallengeButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(cancelEditingChallengeButton)
        }
        
        textLengthIndicatorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(cancelEditingChallengeButton)
        }
    }
    
    private func clearUIState() {
        addButton.isHidden = true
        placeholderLabel.isHidden = true
        challengeTextView.isHidden = true
        contextMenuButton.isHidden = true
        
        challengeCellView.snp.remakeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(placeholderLabel).offset(-20)
            $0.bottom.equalTo(placeholderLabel).offset(20)
        }
    }
    
    private func emptyState() {
        clearUIState()
        
        addButton.isHidden = false
        placeholderLabel.attributedText = NSAttributedString(
            string: "챌린지가 아직 없어요",
            attributes: placeholderTextAttributes
        )
        placeholderLabel.isHidden = false
        
        if let previousChallenge = viewModel.previousChallenge {
            bottomSheetContentView.viewModel.challenge = previousChallenge
            bottomSheetContentView.viewModel.selectedEmoji = previousChallenge.emoji
        }
    }
    
    private func existState() {
        clearUIState()
        
        placeholderLabel.isHidden = false
    }
    
    func addState() {
        clearUIState()
        showEditingButtons()
        endEditingChallengeButton.isEnabled = false
        challengeTextView.isHidden = false
        challengeTextView.becomeFirstResponder()

        placeholderLabel.attributedText = NSAttributedString(
            string: "챌린지를 작성하세요",
            attributes: placeholderTextAttributes
        )
        placeholderLabel.isHidden = false

        challengeTextView.attributedText = NSAttributedString(
            string: "",
            attributes: mainTextAttributes
        )

        challengeCellView.snp.remakeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(challengeTextView).offset(-20)
            $0.bottom.equalTo(challengeTextView).offset(20)
        }
    }
    
    private func modifyState() {
        guard let todayChallenge = viewModel.todayChallenge else { return }
        
        clearUIState()
        showEditingButtons()
        contextMenuButton.isHidden = false
        endEditingChallengeButton.isEnabled = true
        challengeTextView.isHidden = false
        challengeTextView.becomeFirstResponder()
        challengeTextView.tintColor = .tintColor
        challengeTextView.attributedText = NSAttributedString(
            string: todayChallenge.content,
            attributes: mainTextAttributes
        )
        challengeTextView.textAlignment = .center
        
        currentTextLength = challengeTextView.text.count
        
        placeholderLabel.attributedText = NSAttributedString(
            string: "챌린지를 작성하세요",
            attributes: placeholderTextAttributes
        )
        
        challengeCellView.snp.remakeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(challengeTextView).offset(-20)
            $0.bottom.equalTo(challengeTextView).offset(20)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.challengeTextView.selectAll(nil)
        }
    }
    
    func showEditingButtons() {
        UIView.animate(withDuration: 0.3) {
            self.cancelEditingChallengeButton.snp.updateConstraints {
                $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-20)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func hideEditingButtons() {
        UIView.animate(withDuration: 0.3) {
            self.cancelEditingChallengeButton.snp.updateConstraints {
                $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(150)
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate

extension TodayViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        deleteOverFlowedTexts(textView: textView)
        checkTextLength(textView: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText input: String) -> Bool {
        let returnButton = "\n"
        let isTextExist = !textView.text.isEmpty
        
        if input == returnButton && isTextExist {
            stopEditingAndSaveChallenge()
            return false
        } else {
            return true
        }
    }
}

extension TodayViewController {
    private func checkTextLength(textView: UITextView?) {
        guard let textView else { return }
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
            textView.tintColor = .clear
            endEditingChallengeButton.isEnabled = false
//            clearTextButton.isHidden = true
        } else {
            placeholderLabel.isHidden = true
            textView.tintColor = .tintColor
            endEditingChallengeButton.isEnabled = true
//            clearTextButton.isHidden = false
        }
        
        currentTextLength = textView.text.count
    }
    
    private func deleteOverFlowedTexts(textView: UITextView) {
        if textView.text.count > maxTextLength {
            let overflowRange = textView.text.index(textView.text.startIndex, offsetBy: 50)...
            textView.text.removeSubrange(overflowRange)
        }
    }
    
    @objc private func stopEditingAndSaveChallenge() {
        if let todayChallenge = viewModel.todayChallenge {
            self.viewModel.updateChallengeContent(updatingChallenge: todayChallenge, content: challengeTextView.text)
            self.viewModel.updateWidget()
            self.challengeTextView.resignFirstResponder()
            viewModel.todayChallenge = viewModel.getTodayChallenge()
            existState()
        } else {
            self.viewModel.createChallenge(self.challengeTextView.text as String)
            self.viewModel.updateWidget()
            self.challengeTextView.resignFirstResponder()
            viewModel.todayChallenge = viewModel.getTodayChallenge()
            existState()
        }
        hideEditingButtons()
    }
    
    @objc private func cancelEditingChallenge() {
        view.endEditing(true)
        if let todayChallenge = viewModel.todayChallenge {
            let challengeAttrString = NSAttributedString(string: todayChallenge.content, attributes: self.mainTextAttributes)
            let mutableAttrString = NSMutableAttributedString(attributedString: challengeAttrString)

            let whiteSpaceAttachment = NSTextAttachment()
            whiteSpaceAttachment.image = UIImage()
            whiteSpaceAttachment.bounds = CGRect(x: 0, y: 0, width: 2, height: 0)
            mutableAttrString.append(NSAttributedString(attachment: whiteSpaceAttachment))

            let dotAttachment = NSTextAttachment()
            dotAttachment.image = UIImage(named: Assets.dot)
            dotAttachment.bounds = CGRect(x: 0, y: 0, width: 7.5, height: 7.5)
            mutableAttrString.append(NSAttributedString(attachment: dotAttachment))

            self.placeholderLabel.attributedText = mutableAttrString
            existState()
        } else {
            emptyState()
        }
        challengeTextView.text = .none
        hideEditingButtons()
    }
}

// MARK: - Functions
extension TodayViewController {
    
    @objc func settingsDidTap(_ sender: UIButton) {
        let settingVC = SettingViewController(viewModel: SettingViewModel())
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc private func cellDidTap() {
        if viewModel.todayChallenge == nil {
            addButtonDidTap()
        } else {
            modifyState()
        }
    }
    
    @objc private func addButtonDidTap() {
        if viewModel.previousChallenge?.emoji == Emoji.none {
            presentBottomSheet()
        } else {
            addState()
        }
    }
    
    private func presentBottomSheet() {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.dim()
        bottomSheet.modalPresentationStyle = .overFullScreen
        bottomSheet.modalTransitionStyle = .coverVertical
        present(bottomSheet, animated: true)
    }
    
    private func dismissBottomSheet() {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.brighten()
        dismiss(animated: true)
        viewModel.previousChallenge = viewModel.getPreviousChallenge()
    }
    
    private func presentAlert() {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.dim()
        testAlert.modalPresentationStyle = .overFullScreen
        testAlert.modalTransitionStyle = .coverVertical
        present(testAlert, animated: true)
    }
    
    private func dismissAlert() {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.brighten()
        dismiss(animated: true)
    }
}

// MARK: - Bindings
extension TodayViewController {
    
    private func bind() {
        viewModel.$todayChallenge
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if let challengeText = $0?.content {
                    let challengeAttrString = NSAttributedString(string: challengeText, attributes: self?.mainTextAttributes)
                    let mutableAttrString = NSMutableAttributedString(attributedString: challengeAttrString)

                    let whiteSpaceAttachment = NSTextAttachment()
                    whiteSpaceAttachment.image = UIImage()
                    whiteSpaceAttachment.bounds = CGRect(x: 0, y: 0, width: 2, height: 0)
                    mutableAttrString.append(NSAttributedString(attachment: whiteSpaceAttachment))

                    let dotAttachment = NSTextAttachment()
                    dotAttachment.image = UIImage(named: Assets.dot)
                    dotAttachment.bounds = CGRect(x: 0, y: 0, width: 7.5, height: 7.5)
                    mutableAttrString.append(NSAttributedString(attachment: dotAttachment))

                    self?.placeholderLabel.attributedText = mutableAttrString
                    self?.currentTextLength = challengeText.count
                    self?.existState()
                } else {
                    self?.currentTextLength = 0
                    self?.challengeTextView.tintColor = .clear
                    self?.emptyState()
                }
            }
            .store(in: &cancelBag)
    }
}

extension TodayViewController: CustomNavBar {
    private func setNavigationBar() {
        setNavigationBarAppLogo()
        setNavigationBarBackButton()
        setNavigationBarRightIconButton(systemName: "gearshape.fill", action: #selector(settingsDidTap))
    }
}
