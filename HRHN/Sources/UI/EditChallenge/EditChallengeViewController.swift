//
//  EditChallengeViewController.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/30.
//

import UIKit

final class EditChallengeViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: EditChallengeViewModel
    
    private let mainTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 20, weight: .bold),
        .foregroundColor: UIColor.cellLabel,
    ]
    
    private let lengthTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15, weight: .bold),
        .foregroundColor: UIColor.cellLabel,
    ]
    
    private let maxTextLength = 50
    
    private lazy var currentTextLength: Int = viewModel.currentChallenge?.content.count ?? 0 {
        didSet {
            textLengthIndicatorLabel.attributedText = NSAttributedString(
                string: "\(currentTextLength)/\(maxTextLength)",
                attributes: lengthTextAttributes
            )
        }
    }
    
    // MARK: UI
    
    private lazy var titleLabel: UILabel = {
        switch viewModel.mode {
        case .add:
            $0.text = I18N.addTitle
        case .modify:
            $0.text = I18N.updateTitle
        }
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let challengeCardLayoutView = UIView()
    
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private let challengeCard: UIView = {
        $0.backgroundColor = .cellFill
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    private lazy var storageButton: UIButton = { [weak self] in
        var titleAttribute = AttributedString(I18N.storageTitle)
        titleAttribute.font = .systemFont(ofSize: 16)
        $0.configuration?.attributedTitle = titleAttribute
        
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 13))
        $0.setImage(UIImage(systemName: "archivebox", withConfiguration: imageConfig), for: .normal)
        $0.configuration?.imagePadding = 4
        
        $0.configuration?.baseBackgroundColor = .cellFill
        $0.configuration?.baseForegroundColor = .cellLabel
        $0.configuration?.cornerStyle = .fixed
        $0.configuration?.background.cornerRadius = 16
        $0.configuration?.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let action = UIAction { _ in
            self?.storageButtonDidTap()
        }
        $0.addAction(action, for: .touchUpInside)
        
        return $0
    }(UIButton(configuration: .filled()))
    
    private lazy var doneButton: UIFullWidthButton = { [weak self] in
        $0.title = I18N.btnDone
        $0.isOnKeyboard = true
        $0.isEnabled = false
        $0.action = UIAction { _ in
            self?.stopEditingAndSaveChallenge()
        }
        return $0
    }(UIFullWidthButton())
    
    private lazy var placeholderLabel: UILabel = {
        $0.attributedText = NSAttributedString(
            string: I18N.addPlaceholder,
            attributes: mainTextAttributes
        )
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.layer.opacity = 0.3
        $0.isHidden = true
        return $0
    }(UILabel())
    
    private lazy var challengeTextView: UITextView = {
        switch viewModel.mode {
        case .add:
            $0.attributedText = NSAttributedString(
                string: " ",
                attributes: mainTextAttributes
            )
        case .modify:
            $0.attributedText = NSAttributedString(
                string: viewModel.currentChallenge?.content ?? "",
                attributes: mainTextAttributes
            )
        }
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
    
    private lazy var deleteChallengeBarButton: UIBarButtonItem = {
        $0.tintColor = .systemRed
        return $0
    }(UIBarButtonItem(
        title: I18N.deleteButtonTitle,
        style: .plain,
        target: self,
        action: #selector(deleteChallengeBarButtonDidTap)
    ))
    
    private lazy var deleteChallengeAlert: UIAlertController = { [weak self] in
        let deleteAction = UIAlertAction(title: I18N.deleteAlertConfirm, style: .destructive) { _ in
            self?.viewModel.deleteChallenge()
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: I18N.deleteAlertCancel, style: .cancel)
        $0.addAction(deleteAction)
        $0.addAction(cancelAction)
        return $0
    }(UIAlertController(
        title: I18N.deleteAlertTitle,
        message: I18N.deleteAlertMessage,
        preferredStyle: .alert
    ))
    
    private lazy var clearTextButton: UIButton = { [weak self] in
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 12, weight: .bold))
        $0.setImage(UIImage(systemName: "xmark.circle", withConfiguration: imageConfig), for: .normal)
        
        $0.tintColor = .cellLabel
        $0.layer.opacity = 0.7
        
        $0.configuration?.contentInsets = .zero
        
        let action = UIAction { _ in
            self?.challengeTextView.text.removeAll()
            self?.checkTextLength(textView: self?.challengeTextView)
        }
        $0.addAction(action, for: .touchUpInside)
        
        if viewModel.currentChallenge == nil {
            $0.isHidden = true
        }
        return $0
    }(UIButton(configuration: .plain()))
    
    // MARK: LifeCycle
    
    init(viewModel: EditChallengeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        challengeTextView.becomeFirstResponder()
    }
}

// MARK: UI Functions

extension EditChallengeViewController {
    
    private func setUI() {
        view.backgroundColor = .background
        navigationController?.navigationBar.topItem?.title = ""
        
        switch viewModel.mode {
        case .add:
            challengeTextView.attributedText = NSAttributedString(
                string: "",
                attributes: mainTextAttributes
            )
            challengeTextView.delegate = self
        case .modify:
            navigationItem.rightBarButtonItem = deleteChallengeBarButton
        }
        
        textViewDidChange(challengeTextView)
    }
    
    private func setLayout() {
        
        view.addSubviews(
            stackView
        )
        
        stackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        switch viewModel.mode {
        case .add:
            stackView.addArrangedSubviews(
                titleLabel,
                challengeCard,
                storageButton,
                doneButton
            )
        case .modify:
            stackView.addArrangedSubviews(
                titleLabel,
                challengeCard,
                doneButton
            )
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        challengeCard.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(35)
            $0.height.equalTo(180.verticallyAdjusted)
        }
        
        challengeCard.addSubviews(
            challengeTextView,
            placeholderLabel,
            textLengthIndicatorLabel,
            clearTextButton
        )
        
        challengeTextView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20.verticallyAdjusted)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20.verticallyAdjusted)
        }
        
        textLengthIndicatorLabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(20.verticallyAdjusted)
        }
        
        clearTextButton.snp.makeConstraints {
            $0.trailing.equalTo(textLengthIndicatorLabel.snp.leading).offset(-3)
            $0.centerY.equalTo(textLengthIndicatorLabel)
        }
        
        if viewModel.mode == .add {
            storageButton.snp.makeConstraints {
                $0.height.equalTo(50)
                $0.right.equalTo(challengeCard)
            }
        }
        
        doneButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
}

// MARK: UITextViewDelegate

extension EditChallengeViewController: UITextViewDelegate {
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

// MARK: Methods
 
extension EditChallengeViewController {
    
    private func storageButtonDidTap() {
        
    }
    
    @objc
    private func deleteChallengeBarButtonDidTap() {
        self.present(deleteChallengeAlert, animated: true)
    }
    
    private func checkTextLength(textView: UITextView?) {
        guard let textView else { return }
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
            textView.tintColor = .clear
            doneButton.isEnabled = false
            clearTextButton.isHidden = true
        } else {
            placeholderLabel.isHidden = true
            textView.tintColor = .tintColor
            doneButton.isEnabled = true
            clearTextButton.isHidden = false
        }
        
        currentTextLength = textView.text.count
    }
    
    private func deleteOverFlowedTexts(textView: UITextView) {
        if textView.text.count > maxTextLength {
            let overflowRange = textView.text.index(textView.text.startIndex, offsetBy: 50)...
            textView.text.removeSubrange(overflowRange)
        }
    }
    
    private func stopEditingAndSaveChallenge() {
        switch viewModel.mode {
        case .add:
            self.viewModel.createChallenge(self.challengeTextView.text as String)
            self.viewModel.updateWidget()
            self.navigationController?.popToRootViewController(animated: true)
        case .modify:
            self.viewModel.updateChallenge(challengeTextView.text)
            self.viewModel.updateWidget()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
