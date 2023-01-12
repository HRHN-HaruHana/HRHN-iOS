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
    
    private lazy var titleLabel: UILabel = {
        $0.text = "오늘의 챌린지"
        $0.textColor = UIColor.point
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var dateLabel: UILabel = {
        $0.text = Date().formatted("YYYY.MM.dd")
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.numberOfLines = 0
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
    
    private lazy var emptyStackView: UIStackView = {
        $0.spacing = 20
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    private lazy var challengeLabel: UILabel = {
        $0.textColor = .cellLabel
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var emptyLabel: UILabel = {
        $0.text = "오늘의 챌린지가 아직 없어요"
        $0.textColor = .dim
        $0.font = .systemFont(ofSize: 16, weight: .light)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var addButton: UIButton = {
        $0.setTitle("챌린지 추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .point
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(addButtonDidTap(_:)), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))
    
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
        setNavigationBar()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateLabel.text = Date().formatted("YYYY.MM.dd")
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
    
    @objc func addButtonDidTap(_ sender: UIButton) {
        viewModel.addButtonDidTap(navigationController: navigationController)
    }
    
    @objc private func cardDidTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if viewModel.isTodayChallengeExist() {
            let modifyVC = ModifyViewController(viewModel: ModifyViewModel())
            modifyVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(modifyVC, animated: true)
        }
    }
}

// MARK: - Bindings
extension TodayViewController {
    
    private func bind() {
        viewModel.fetchTodayChallenge()
        viewModel.todayChallenge.subscribe { value in
            DispatchQueue.main.async {
                self.challengeLabel.text = value
                if value == nil {
                    self.makeEmptyState()
                } else {
                    self.makeChallengeState()
                }
            }
        }
    }
}

// MARK: - UI Functions
extension TodayViewController {
    private func setUI(){
        view.backgroundColor = .background
        view.addSubviews(titleLabel, dateLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        view.addSubviews(cardView)
        cardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40.constraintMultiplierTargetValue.adjusted)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(400.constraintMultiplierTargetValue.adjusted)
        }
        
    }
    
    private func makeChallengeState(){
        emptyStackView.removeFromSuperview()
        cardView.addSubviews(challengeLabel)
        challengeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.constraintMultiplierTargetValue.adjusted)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func makeEmptyState(){
        challengeLabel.removeFromSuperview()
        cardView.addSubviews(emptyStackView)
        emptyStackView.addArrangedSubviews(emptyLabel, addButton)
        emptyStackView.snp.makeConstraints {
            $0.center.equalTo(self.cardView.snp.center)
        }
        addButton.snp.makeConstraints {
            $0.width.equalTo(109)
            $0.height.equalTo(40)
        }
    }
    
    private func setNavigationBar() {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsDidTap))
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
