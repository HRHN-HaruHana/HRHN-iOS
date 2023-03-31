//
//  UIAlert.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/07.
//

import UIKit

final class UIAlert: UIView {
    
    // MARK: - Properties
    
    var titleString: String = "" {
        didSet {
            titleLabel.text = titleString
        }
    }
    
    var descriptionString: String = "" {
        didSet {
            descriptionLabel.text = descriptionString
        }
    }
    
    var cancelTitle = "" {
        didSet {
            cancelButton.title = cancelTitle
        }
    }
    
    var cancelForegroundColor: UIColor = .label {
        didSet {
            cancelButton.baseForegroundColor = cancelForegroundColor
        }
    }
    
    var cancelBackgroundColor: UIColor = .cellFill {
        didSet {
            cancelButton.baseBackgroundColor = cancelBackgroundColor
        }
    }
    
    var cancelAction: UIAction = UIAction { _ in } {
        didSet {
            cancelButton.addAction(cancelAction, for: .touchUpInside)
        }
    }
    
    var confirmTitle = "" {
        didSet {
            confirmButton.title = confirmTitle
        }
    }
    
    var confirmForegroundColor: UIColor = .label {
        didSet {
            confirmButton.baseForegroundColor = confirmForegroundColor
        }
    }
    
    var confirmBackgroundColor: UIColor = .cellFill {
        didSet {
            confirmButton.baseBackgroundColor = confirmBackgroundColor
        }
    }
    
    var confirmAction: UIAction = UIAction { _ in } {
        didSet {
            confirmButton.addAction(confirmAction, for: .touchUpInside)
        }
    }
    
    var alertViewPanGestureRecognizer = UIPanGestureRecognizer(target: nil, action: nil) {
        didSet {
            alertView.addGestureRecognizer(alertViewPanGestureRecognizer)
        }
    }

    var dimmedViewTapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil) {
        didSet {
            dimmedView.addGestureRecognizer(dimmedViewTapGestureRecognizer)
        }
    }
    
    // MARK: - UI Properties
    
    private let dimmedView = UIDimmedView()
    private let grabber = UIGrabber()
    
    private let alertView: UIView = {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    private let contentsStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 40
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    private let labelStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    private let titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.textColor = .secondaryLabel
        $0.font = UIFont.systemFont(ofSize: 16)
        return $0
    }(UILabel())
    
    private let buttonStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let cancelButton = UIAlertButton()
    private let confirmButton = UIAlertButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Functions
    
    private func getUIWindow() -> UIWindow {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return UIWindow() }
        return window
    }
    
    func setLayout() {
        let window = getUIWindow()
        
        window.addSubviews(
            dimmedView,
            alertView
        )
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints {
            $0.height.equalTo(220)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(window.snp.bottom).offset(20)
        }
        
        alertView.addSubviews(
            contentsStackView
        )
        
        contentsStackView.addArrangedSubviews(
            grabber,
            labelStackView,
            buttonStackView
        )
        
        contentsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
        
        grabber.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(6)
        }
        
        labelStackView.addArrangedSubviews(
            titleLabel,
            descriptionLabel
        )
        
        labelStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        buttonStackView.addArrangedSubviews(
            cancelButton,
            confirmButton
        )
        
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    func presentAlert() {
        let window = getUIWindow()
        
        window.rootViewController?.navigationController?.navigationBar.isUserInteractionEnabled = false
        window.rootViewController?.tabBarController?.tabBar.isUserInteractionEnabled = false
        
        alertView.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        alertView.layer.opacity = 1
        
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.isUserInteractionEnabled = true
            self.dimmedView.layer.opacity = 0.3
            window.layoutIfNeeded()
        }
    }
    
    func dismissAlert() {
        let window = getUIWindow()
        
        window.rootViewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
        window.rootViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        
        alertView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(window.snp.bottom).offset(20)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.isUserInteractionEnabled = false
            self.dimmedView.layer.opacity = 0
            window.layoutIfNeeded()
        }
    }
    
    func dismissAlertWithAction(nextActionView: Any) {
        let window = getUIWindow()
        
        window.rootViewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
        window.rootViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        
        alertView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(window.snp.bottom).offset(20)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.isUserInteractionEnabled = false
            self.dimmedView.layer.opacity = 0
            window.layoutIfNeeded()
        }
        
        if let nextActionView = nextActionView as? UITextView {
            nextActionView.becomeFirstResponder()
        }
    }
}

extension UIAlert: Panable {
    func alertDidPanned(sender: UIPanGestureRecognizer, nextActionView: Any) {
        setPanGesture(
            sender: sender
        ) { [weak self] in
            self?.dismissAlertWithAction(nextActionView: nextActionView)
        }
    }
}
