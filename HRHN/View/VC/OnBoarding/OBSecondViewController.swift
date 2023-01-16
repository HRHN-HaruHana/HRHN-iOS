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
        $0.text = I18N.obWidgetTitle
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var subTitleLabel: UILabel = {
        $0.text = I18N.obWidgetTitle2
        $0.textColor = .dim
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "mock") // TODO: Localization
        return $0
    }(UIImageView())
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
    
    private func setUI() {
        view.addSubviews(titleLabel, subTitleLabel, imageView)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(80.constraintMultiplierTargetValue.adjusted)
            $0.height.equalTo(80)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(70)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(270.adjusted)
            $0.height.equalTo(390.adjusted)
        }
    }
}
