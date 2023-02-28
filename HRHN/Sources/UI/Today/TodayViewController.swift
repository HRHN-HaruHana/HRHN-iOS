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
    
    // MARK: - Properties
    private let viewModel: TodayViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private let titleLabel: UILabel = {
        $0.text = I18N.todayTitle
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    private let challengeLayoutView: UIView = {
        return $0
    }(UIView())
    
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
    
    private lazy var bottomSheetView: UIView = {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(cellDidPanned)
        )
        $0.addGestureRecognizer(panGesture)
        return $0
    }(UIView())
    
    private lazy var grabber: UIView = {
        $0.backgroundColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1)
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    private lazy var dimmedView: UIView = {
        $0.backgroundColor = .black
        $0.layer.opacity = 0
        $0.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissBottomSheet)
        )
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(UIView())
    
    private let bottomSheetHeight: CGFloat = 336
    
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
    
    private let maxTextLength = 50
    
//    private lazy var currentTextLength: Int = editChallengeViewModel.currentChallenge?.content.count ?? 0 {
//        didSet {
//            textLengthIndicatorLabel.attributedText = NSAttributedString(
//                string: "\(currentTextLength)/\(maxTextLength)",
//                attributes: lengthTextAttributes
//            )
//        }
//    }
    
    private lazy var placeholderLabel: UILabel = {
        $0.attributedText = NSAttributedString(
            string: "",
            attributes: mainTextAttributes
        )
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
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
    
//    private lazy var textLengthIndicatorLabel: UILabel = {
//        $0.attributedText = NSAttributedString(
//            string: "\(currentTextLength)/\(maxTextLength)",
//            attributes: lengthTextAttributes
//        )
//        $0.layer.opacity = 0.7
//        return $0
//    }(UILabel())
    
    // MARK: - LifeCycle
    
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
        viewModel.fetchTodayChallenge()
        viewModel.fetchPreviousChallenge()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if challengeTextView.isFirstResponder {
            self.view.endEditing(true)
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
//            if viewModel.todayChallenge == nil {
//                emptyState()
//            } else {
//                existState()
//            }
            challengeTextView.text = .none
        }
    }
}

// MARK: - UI Functions
extension TodayViewController {
    
    private func setLayout() {
        view.addSubviews(
            challengeLayoutView,
            dimmedView
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
            challengeTextView
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

        addButton.snp.makeConstraints {
            $0.top.equalTo(challengeCellView.snp.bottom).offset(10)
            $0.right.equalTo(challengeCellView)
            $0.height.equalTo(50)
        }
    }
    
    private func clearUIState() {
        bottomSheetView.removeFromSuperview()
        addButton.isHidden = true
        placeholderLabel.isHidden = true
        challengeTextView.isHidden = true
        
        challengeCellView.snp.remakeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(placeholderLabel).offset(-20)
            $0.bottom.equalTo(placeholderLabel).offset(20)
        }
    }
    
    private func emptyState() {
        clearUIState()
        
        addButton.isHidden = false
        placeholderLabel.isHidden = false
        placeholderLabel.attributedText = NSAttributedString(
            string: "챌린지가 아직 없어요",
            attributes: placeholderTextAttributes
        )
        
        if let previousChallenge = viewModel.previousChallenge {
            let reviewViewHC = UIHostingController(rootView: ReviewView(viewModel: ReviewViewModel(from: self, challenge: previousChallenge)))
            
            view.addSubviews(
                bottomSheetView
            )
            
            bottomSheetView.snp.makeConstraints {
                $0.height.equalTo(bottomSheetHeight)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.top.equalTo(view.snp.bottom)
            }
            
            bottomSheetView.addSubviews(
                grabber,
                reviewViewHC.view
            )
            
            addChild(reviewViewHC)
            reviewViewHC.didMove(toParent: self)
            reviewViewHC.view.snp.makeConstraints {
                $0.top.equalTo(grabber.snp.bottom).offset(15)
                $0.horizontalEdges.equalTo(bottomSheetView).inset(20)
            }
            
            grabber.snp.makeConstraints {
                $0.width.equalTo(60)
                $0.height.equalTo(6)
                $0.top.equalToSuperview().inset(10)
                $0.centerX.equalToSuperview()
            }
            
            dimmedView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func existState() {
        clearUIState()
        
        placeholderLabel.isHidden = false
    }
    
    func addState() {
        clearUIState()
        challengeTextView.isHidden = false
        challengeTextView.becomeFirstResponder()
        
        placeholderLabel.isHidden = false
        placeholderLabel.attributedText = NSAttributedString(
            string: "챌린지를 작성하세요",
            attributes: placeholderTextAttributes
        )
        
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
        challengeTextView.isHidden = false
        challengeTextView.becomeFirstResponder()
        placeholderLabel.attributedText = NSAttributedString(
            string: "챌린지를 작성하세요",
            attributes: placeholderTextAttributes
        )
        
        challengeTextView.attributedText = NSAttributedString(
            string: todayChallenge.content,
            attributes: mainTextAttributes
        )
        challengeTextView.textAlignment = .center
        
        challengeCellView.snp.remakeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(challengeTextView).offset(-20)
            $0.bottom.equalTo(challengeTextView).offset(20)
        }
    }
    
    private func presentBottomSheet() {
        bottomSheetView.layer.opacity = 1
        bottomSheetView.snp.remakeConstraints {
            $0.height.equalTo(bottomSheetHeight)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.layer.zPosition = -1
            self.tabBarController?.tabBar.layer.zPosition = -1
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            self.dimmedView.layer.opacity = 0.3
            self.dimmedView.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissBottomSheet() {
        bottomSheetView.snp.remakeConstraints {
            $0.height.equalTo(bottomSheetHeight)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(view.snp.bottom)
        }
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.layer.zPosition = 0
            self.tabBarController?.tabBar.layer.zPosition = 0
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            self.dimmedView.isUserInteractionEnabled = false
            self.dimmedView.layer.opacity = 0
            self.view.layoutIfNeeded()
        }
        viewModel.fetchPreviousChallenge()
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
//            doneButton.isEnabled = false
//            clearTextButton.isHidden = true
        } else {
            placeholderLabel.isHidden = true
            textView.tintColor = .tintColor
//            doneButton.isEnabled = true
//            clearTextButton.isHidden = false
        }
        
//        currentTextLength = textView.text.count
    }
    
    private func deleteOverFlowedTexts(textView: UITextView) {
        if textView.text.count > maxTextLength {
            let overflowRange = textView.text.index(textView.text.startIndex, offsetBy: 50)...
            textView.text.removeSubrange(overflowRange)
        }
    }
    
    private func stopEditingAndSaveChallenge() {
        if viewModel.todayChallenge == nil {
            self.viewModel.createChallenge(self.challengeTextView.text as String)
            self.viewModel.updateWidget()
            self.challengeTextView.resignFirstResponder()
            viewModel.fetchTodayChallenge()
            existState()
        } else {
            self.viewModel.updateChallenge(challengeTextView.text)
            self.viewModel.updateWidget()
            self.challengeTextView.resignFirstResponder()
            viewModel.fetchTodayChallenge()
            existState()
        }
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
    
    @objc func cellDidPanned(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let translationLimit: CGFloat = 30
        let translationXFactor: CGFloat = 1.005
        let translationYFactor: CGFloat = 1.005
        
        guard let pannedView = sender.view else { return }
        
        var translationX: CGFloat {
            if translation.x > 0 {
                return translationLimit * (1-1/pow(translationXFactor, translation.x))
            } else {
                return -translationLimit * (1-1/pow(translationXFactor, translation.x.magnitude))
            }
        }
        
        var translationY: CGFloat {
            if translation.y > 0 {
                return translation.y
            } else {
                return -translationLimit * (1-1/pow(translationYFactor, translation.y.magnitude))
            }
        }
        
        pannedView.transform = CGAffineTransform(
            translationX: translationX,
            y: translationY
        )
        
        switch sender.state {
        case .changed:
            if translation.y > 0 {
                bottomSheetView.layer.opacity = 1 - Float(1-1/pow(translationYFactor, translation.y))
            }
        case .ended:
            if translation.y > 100 {
                UIView.animate(withDuration: 0.3) {
                    self.dismissBottomSheet()
                    pannedView.transform = .identity
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    pannedView.transform = .identity
                    self.bottomSheetView.layer.opacity = 1
                }
            }
        default:
            break
        }
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
                    self?.existState()
                } else {
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
