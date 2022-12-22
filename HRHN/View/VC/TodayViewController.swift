//
//  TodayViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//

import UIKit
import SnapKit

final class TodayViewController: UIViewController {
    
    private let sampleSentence: String?
    
    // MARK: - Properties
    private lazy var testButton: UIButton = {
        $0.configuration = .filled()
        $0.setTitle("코어데이터테스트", for: .normal)
        $0.addTarget(self, action: #selector(testDidTap(_:)), for: .primaryActionTriggered)
        return $0
    }(UIButton())
    
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
        $0.backgroundColor = .challengeCardFill
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    private lazy var stackView: UIStackView = {
        $0.spacing = 20
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .vertical
    }(UIStackView())
    
    private lazy var challengeLabel: UILabel = {
        $0.text = sampleSentence ?? ""
        $0.textColor = .challengeCardLabel
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
        $0.setTitle("Button", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .point
        $0.layer.cornerRadius = 50
        $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
    }(UIButton(type: .system))

    // MARK: - LifeCycle
    
    init() {
        self.sampleSentence = "텍스트가 길어졌을 경우의 레이아웃 입니다"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
    }
    
}

// MARK: - Functions
extension TodayViewController {
    
    @objc func testDidTap(_ sender: UIButton) {
        
    }
    
    @objc func settingsDidTap(_ sender: UIButton) {
        
    }
    
}

// MARK: - UI Functions
extension TodayViewController {
    private func setUI(){
        view.backgroundColor = .systemBackground
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
        
        cardView.addSubviews(challengeLabel)
        
        challengeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.constraintMultiplierTargetValue.adjusted)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    private func setNavigationBar() {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsDidTap))
        rightBarButton.tintColor = .label
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
