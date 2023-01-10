//
//  ModifyViewController.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/30.
//

import UIKit

final class ModifyViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: ModifyViewModel
    
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
    
    private let titleLabel: UILabel = {
        $0.text = "오늘의 챌린지를\n수정하세요"
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let modifyChallengeCardLayoutView: UIView = {
        return $0
    }(UIView())
    
    private let modifyChallengeCard: UIView = {
        $0.backgroundColor = .cellFill
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    private lazy var doneButton: UIFullWidthButton = {
        $0.title = "완료"
        $0.isOnKeyboard = true
        $0.isEnabled = false
        $0.action = UIAction { _ in
            self.doneButtonDidTap()
        }
        return $0
    }(UIFullWidthButton())
    
    private lazy var placeholderLabel: UILabel = {
        $0.attributedText = NSAttributedString(
            string: "오늘의 다짐, 목표, 습관,\n영어문장, 할일 혹은\n무엇이든 좋아요",
            attributes: mainTextAttributes
        )
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.layer.opacity = 0.3
        $0.isHidden = true
        return $0
    }(UILabel())
    
    private lazy var modifyChallengeTextView: UITextView = {
        $0.attributedText = NSAttributedString(
            string: viewModel.currentChallenge?.content ?? "",
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
    
    // MARK: LifeCycle
    
    init(viewModel: ModifyViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        modifyChallengeTextView.becomeFirstResponder()
    }
}

// MARK: UI Functions

private extension ModifyViewController {
    
    func setUI() {
        view.backgroundColor = .background
        textViewDidChange(modifyChallengeTextView)
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setLayout() {
        view.addSubviews(
            titleLabel,
            modifyChallengeCardLayoutView,
            modifyChallengeCard,
            placeholderLabel,
            modifyChallengeTextView,
            doneButton,
            textLengthIndicatorLabel
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        doneButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        modifyChallengeCardLayoutView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(doneButton.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        modifyChallengeCard.snp.makeConstraints {
            $0.center.equalTo(modifyChallengeCardLayoutView)
            $0.horizontalEdges.equalToSuperview().inset(35)
            $0.height.equalTo(200.adjusted)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.center.equalTo(modifyChallengeCard)
            $0.edges.equalTo(modifyChallengeCard).inset(20.adjusted)
        }
        
        modifyChallengeTextView.snp.makeConstraints {
            $0.center.equalTo(modifyChallengeCard)
            $0.horizontalEdges.equalTo(modifyChallengeCard).inset(20.adjusted)
        }
        
        textLengthIndicatorLabel.snp.makeConstraints {
            $0.trailing.bottom.equalTo(modifyChallengeCard).inset(20.adjusted)
        }
    }
    
    func doneButtonDidTap() {
        self.viewModel.updateChallenge(modifyChallengeTextView.text)
        self.viewModel.updateWidget()
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: UITextViewDelegate

extension ModifyViewController: UITextViewDelegate {
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
