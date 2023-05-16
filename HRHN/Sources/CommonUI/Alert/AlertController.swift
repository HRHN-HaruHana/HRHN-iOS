//
//  AlertController.swift
//  HRHN
//
//  Created by 민채호 on 2023/05/15.
//

import UIKit

final class AlertController: UIViewController {
    
    var alertWillDismiss: (() -> Void)?
    
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
            backgroundView.addGestureRecognizer(dimmedViewTapGestureRecognizer)
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var backgroundView: UIView = {
        $0.backgroundColor = .clear
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissAlert)
        )
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UIView())
    
    private let grabber = UIGrabber()
    
    private lazy var alertView: UIView = {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGestureHandler)
        )
        $0.addGestureRecognizer(panGestureRecognizer)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
}

extension AlertController {
    
    private func setLayout() {
        
        view.addSubviews(
            backgroundView,
            alertView
        )
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints {
            $0.height.equalTo(220)
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
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
}

extension AlertController {
    
    @objc private func dismissAlert() {
        alertView.layer.opacity = 1
        alertWillDismiss?()
    }
}

extension AlertController: Panable {
    
    @objc private func panGestureHandler(sender: UIPanGestureRecognizer) {
        setPanGesture(
            sender: sender
        ) { [weak self] in
            self?.dismissAlert()
        }
    }
}
