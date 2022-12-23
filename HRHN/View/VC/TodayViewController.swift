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
    
    private lazy var emptyStackView: UIStackView = {
        $0.spacing = 20
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .vertical
        return $0
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
        $0.setTitle("챌린지 추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .point
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(addButtonDidTap(_:)), for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    // MARK: - LifeCycle
    
    init() {
        self.sampleSentence = nil // TEST HERE
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
    
    @objc func settingsDidTap(_ sender: UIButton) {
        // TODO: - GO TO SETTINGS
    }
    
    @objc func addButtonDidTap(_ sender: UIButton) {
        // TODO: - GO TO ADD-CHALLENGE
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
        
        if sampleSentence != nil {
            cardView.addSubviews(challengeLabel)
            
            challengeLabel.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(20.constraintMultiplierTargetValue.adjusted)
                $0.centerY.equalToSuperview()
            }
        } else {
            cardView.addSubviews(emptyStackView)
            emptyStackView.addArrangedSubviews(emptyLabel, addButton)
            
            emptyStackView.snp.makeConstraints {
                $0.center.equalTo(cardView.snp.center)
            }
            
            addButton.snp.makeConstraints {
                $0.width.equalTo(109)
                $0.height.equalTo(40)
            }
            
            
        }
   
    }
    
    private func setNavigationBar() {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsDidTap))
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
