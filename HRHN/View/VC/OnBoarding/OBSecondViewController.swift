//
//  OBSecondViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/30.
//

import UIKit
import SnapKit

class OBSecondViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        $0.text = "위젯으로 챌린지를\n리마인드하세요"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var subTitleLabel: UILabel = {
        $0.text = "*락스크린 지원 (지원예정: 홈/사이드 위젯)"
        $0.textColor = .dim
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    init(imageName: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension OBSecondViewController {
    
    func setUI() {
        view.addSubviews(titleLabel, subTitleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(80.constraintMultiplierTargetValue.adjusted)
            $0.height.equalTo(80)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
    }
}
