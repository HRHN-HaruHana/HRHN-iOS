//
//  AddViewController.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/28.
//

import UIKit

final class AddViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: AddViewModel
    
    private let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 20, weight: .bold),
        .foregroundColor: UIColor.challengeCardLabel,
        .baselineOffset: 2
    ]
    
    private let titleLabel: UILabel = {
        $0.text = "오늘의 챌린지를\n작성해주세요"
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let addChallengeCardLayoutView: UIView = {
        return $0
    }(UIView())
    
    private let addChallengeCard: UIView = {
        $0.backgroundColor = .challengeCardFill
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
            attributes: attributes
        )
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.layer.opacity = 0.3
        return $0
    }(UILabel())
    
    private lazy var addChallengeTextView: UITextView = {
        $0.attributedText = NSAttributedString(
            string: " ",
            attributes: attributes
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
        return $0
    }(UITextView())
    
    // MARK: LifeCycle
    
    init(viewModel: AddViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setUI()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addChallengeTextView.becomeFirstResponder()
    }
}

// MARK: Bindings

private extension AddViewController {
    
    func bind() {
        
    }
}

// MARK: UI Functions

private extension AddViewController {
    
    func setUI() {
        view.backgroundColor = .background
        
        addChallengeTextView.attributedText = NSAttributedString(
            string: "",
            attributes: attributes
        )
        addChallengeTextView.delegate = self
        textViewDidChange(addChallengeTextView)
        
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setLayout() {
        view.addSubviews(
            titleLabel,
            addChallengeCardLayoutView,
            addChallengeCard,
            placeholderLabel,
            addChallengeTextView,
            doneButton
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        doneButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        addChallengeCardLayoutView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(doneButton.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addChallengeCard.snp.makeConstraints {
            $0.center.equalTo(addChallengeCardLayoutView)
            $0.horizontalEdges.equalToSuperview().inset(35)
            $0.height.equalTo(200.adjusted)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.center.equalTo(addChallengeCard)
            $0.edges.equalTo(addChallengeCard).inset(20.adjusted)
        }
        
        addChallengeTextView.snp.makeConstraints {
            $0.center.equalTo(addChallengeCard)
            $0.horizontalEdges.equalTo(addChallengeCard).inset(20.adjusted)
        }
    }
    
    func doneButtonDidTap() {
        self.viewModel.createChallenge(self.addChallengeTextView.text as String)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: UITextViewDelegate

extension AddViewController: UITextViewDelegate {
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
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            doneButtonDidTap()
            return false
        }
        return true
    }
}

// MARK: - Preview

#if DEBUG
final class AddViewNavigationPreview: UIViewController {
    private let button: UIFullWidthButton = {
        $0.title = "내비게이션바 확인"
        return $0
    }(UIFullWidthButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setLayout()
    }
    
    func setButton() {
        button.action = UIAction { _ in
            self.navigationController?.pushViewController(AddViewController(viewModel: AddViewModel()), animated: true)
        }
    }
    
    func setLayout() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

import SwiftUI

struct AddViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: AddViewNavigationPreview())
            .toPreview()
            .ignoresSafeArea()
    }
}
#endif
