//
//  RecordHeaderView.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/24.
//

import UIKit
import SnapKit


final class RecordHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties

    private lazy var headerView = UIView()

    private lazy var titleLabel: UILabel = {
        $0.text = "지난 챌린지"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
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

extension RecordHeaderView {

    private func setUI() {
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubviews(titleLabel)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
    }
}
