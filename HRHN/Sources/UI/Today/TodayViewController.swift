//
//  TodayViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//

import UIKit
import SnapKit

final class TodayViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: TodayViewModel
    
    private let titleLabel: UILabel = {
        $0.text = I18N.todayTitle
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    private lazy var cardView: UIView = {
        $0.backgroundColor = .cellFill
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardDidTap(tapGestureRecognizer:)))
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(UIView())
    
    private lazy var challengeLabel: UILabel = {
        $0.textColor = .cellLabel
        $0.font = .systemFont(ofSize: 26, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var emptyLabel: UILabel = {
        $0.text = I18N.todayEmpty
        $0.textColor = .cellLabel.withAlphaComponent(0.3)
        $0.font = .systemFont(ofSize: 26, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
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
        
        $0.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return $0
    }(UIButton(configuration: .filled()))
    
    private lazy var blackBackground: UIView = {
        $0.backgroundColor = .black
        $0.layer.opacity = 0
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(blackBackgroundTapped)
        )
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(UIView())
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
}

// MARK: - Functions
extension TodayViewController {
    
    @objc func settingsDidTap(_ sender: UIButton) {
        let settingVC = SettingViewController(viewModel: SettingViewModel())
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc private func cardDidTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if viewModel.isTodayChallengeExist() {
            let modifyVC = EditChallengeViewController(viewModel: EditChallengeViewModel(mode: .modify))
            modifyVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(modifyVC, animated: true)
        } else {
            viewModel.addButtonDidTap(navigationController: navigationController)
        }
    }
    
    @objc func addButtonTapped() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            // https://stackoverflow.com/a/33213111
            self?.navigationController?.navigationBar.layer.zPosition = -1
            self?.tabBarController?.tabBar.layer.zPosition = -1
            self?.blackBackground.layer.opacity = 0.3
        }
    }
    
    @objc func blackBackgroundTapped() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.blackBackground.layer.opacity = 0
            self?.navigationController?.navigationBar.layer.zPosition = 0
            self?.tabBarController?.tabBar.layer.zPosition = 0
        }
    }
}

// MARK: - Bindings
extension TodayViewController {
    
    private func bind() {
        viewModel.fetchTodayChallenge()
        viewModel.todayChallenge.subscribe { value in
            DispatchQueue.main.async { [weak self] in
                if let value {
                    let challengeText = value
                    let mutableAttrString = NSMutableAttributedString(string: challengeText)
                    
                    let whiteSpaceAttachment = NSTextAttachment()
                    whiteSpaceAttachment.image = UIImage()
                    whiteSpaceAttachment.bounds = CGRect(x: 0, y: 0, width: 2, height: 0)
                    mutableAttrString.append(NSAttributedString(attachment: whiteSpaceAttachment))
                    
                    let dotAttachment = NSTextAttachment()
                    dotAttachment.image = UIImage(named: Assets.dot)
                    dotAttachment.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
                    mutableAttrString.append(NSAttributedString(attachment: dotAttachment))
                    
                    self?.challengeLabel.attributedText = mutableAttrString
                    self?.makeChallengeState()
                } else {
                    self?.makeEmptyState()
                }
            }
        }
    }
}

// MARK: - UI Functions
extension TodayViewController {
    
    private func makeChallengeState() {
        emptyLabel.removeFromSuperview()
        addButton.removeFromSuperview()
        
        view.addSubviews(
            titleLabel,
            cardView,
            challengeLabel
        )
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(cardView.snp.top).offset(-10)
            $0.left.equalTo(cardView)
        }
        
        challengeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(80)
        }
        
        cardView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.top.equalTo(challengeLabel).offset(-20)
            $0.bottom.equalTo(challengeLabel).offset(20)
        }
    }
    
    private func makeEmptyState() {
        challengeLabel.removeFromSuperview()
        
        view.addSubviews(
            titleLabel,
            cardView,
            emptyLabel,
            addButton,
            blackBackground
        )
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(cardView.snp.top).offset(-10)
            $0.left.equalTo(cardView)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(80)
        }
        
        cardView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.top.equalTo(emptyLabel).offset(-20)
            $0.bottom.equalTo(emptyLabel).offset(20)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(10)
            $0.right.equalTo(cardView)
            $0.height.equalTo(50)
        }
        
        blackBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension TodayViewController: CustomNavBar {
    private func setNavigationBar() {
        setNavigationBarAppLogo()
        setNavigationBarBackButton()
        setNavigationBarRightIconButton(systemName: "gearshape.fill", action: #selector(settingsDidTap))
    }
}
