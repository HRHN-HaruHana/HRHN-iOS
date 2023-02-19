//
//  StorageHeaderView.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//

import UIKit
import SnapKit

final class StorageHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties

    private lazy var headerView = UIView()

    private lazy var titleLabel: UILabel = {
        $0.text = "챌린지 바구니"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var subTitleLabel: UILabel = {
        $0.text = "챌린지를 담아두고 매일 편하게 오늘의 챌린지로 등록하세요"
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    // MARK: - LifeCycle
    
    override init(reuseIdentifier: String?) {
       super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Function

extension StorageHeaderView {

    private func setUI() {
        contentView.backgroundColor = .background
        
        contentView.addSubviews(titleLabel, subTitleLabel)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
        }
        
    }
}
