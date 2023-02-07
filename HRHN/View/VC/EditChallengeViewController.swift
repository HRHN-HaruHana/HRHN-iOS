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
    
    private enum DynamicPoints {
        static let verticalSpacing: CGFloat = DeviceManager.shared.isHomeButtonDevice() ? 10 : 20
        static let padding: CGFloat = DeviceManager.shared.isHomeButtonDevice() ? 10 : 20
        static let cardHeight: CGFloat = DeviceManager.shared.isHomeButtonDevice() ? 140 : 180
    }
    
    private let mainTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 20, weight: .bold),
        .foregroundColor: UIColor.cellLabel,
        .baselineOffset: 2
    ]
    
    private let lengthTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15, weight: .bold),
        .foregroundColor: UIColor.cellLabel,
        .baselineOffset: 2
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
    
    private lazy var cardAndButtonStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.spacing = DynamicPoints.verticalSpacing
        return $0
    }(UIStackView())
    
    private let challengeCard: UIView = {
        $0.backgroundColor = .cellFill
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    private lazy var storageButton: UIButton = { [weak self] in
        var titleAttribute = AttributedString("바구니")
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
            self?.bucketButtonDidTap()
        }
        $0.addAction(action, for: .touchUpInside)
        
        return $0
    }(UIButton(configuration: .filled()))
    
    private lazy var doneButton: UIFullWidthButton = { [weak self] in
        $0.title = I18N.btnDone
        $0.isOnKeyboard = true
        $0.isEnabled = false
        $0.action = UIAction { _ in
            self?.doneButtonDidTap()
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

private extension EditChallengeViewController {
    
    func setUI() {
        view.backgroundColor = .background
        navigationController?.navigationBar.topItem?.title = ""
        
        if viewModel.mode == .add {
            challengeTextView.attributedText = NSAttributedString(
                string: "",
                attributes: mainTextAttributes
            )
            challengeTextView.delegate = self
        }
        
        textViewDidChange(challengeTextView)
    }
    
    func setLayout() {
        view.addSubviews(
            titleLabel,
            challengeCardLayoutView,
            challengeCard,
            placeholderLabel,
            challengeTextView,
            doneButton,
            textLengthIndicatorLabel
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(DynamicPoints.verticalSpacing)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        doneButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        challengeCardLayoutView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(DynamicPoints.verticalSpacing)
            $0.bottom.equalTo(doneButton.snp.top).offset(-DynamicPoints.verticalSpacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        challengeCardLayoutView.addSubview(cardAndButtonStackView)
        
        cardAndButtonStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(35)
        }
        
        switch viewModel.mode {
        case .add:
            cardAndButtonStackView.addArrangedSubviews(
                challengeCard,
                storageButton
            )
        case .modify:
            cardAndButtonStackView.addArrangedSubviews(challengeCard)
        }
        
        challengeCard.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(DynamicPoints.cardHeight)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.center.equalTo(challengeCard)
            $0.edges.equalTo(challengeCard).inset(20.adjusted)
        }
        
        challengeTextView.snp.makeConstraints {
            $0.center.equalTo(challengeCard)
            $0.horizontalEdges.equalTo(challengeCard).inset(DynamicPoints.padding)
        }
        
        textLengthIndicatorLabel.snp.makeConstraints {
            $0.trailing.bottom.equalTo(challengeCard).inset(DynamicPoints.padding)
        }
        
        storageButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    func doneButtonDidTap() {
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
    
    func bucketButtonDidTap() {
        
    }
}

// MARK: UITextViewDelegate

extension EditChallengeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
            textView.tintColor = .clear
            doneButton.isEnabled = false
        } else {
            placeholderLabel.isHidden = true
            textView.tintColor = .tintColor
            doneButton.isEnabled = true
        }
        
        if textView.text.count > maxTextLength {
            textView.text.removeLast()
        }
        
        currentTextLength = textView.text.count
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView.text.count > 0 {
                doneButtonDidTap()
            }
            return false
        }
        return true
    }
}
