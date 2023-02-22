//
//  UITableView+.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//

import UIKit
import Foundation

extension UITableView {
    
    enum EmptyViewType {
        case achivements
        case storage
    }
    
    func setEmptyView(message: String, type: EmptyViewType) {
        let emptyView = UIView(frame: CGRect(x: self.center.x,
                                             y: self.center.y,
                                             width: self.bounds.size.width,
                                             height: self.bounds.size.height))
        
        let iconView: UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(systemName: (type == .achivements)
                               ? "ellipsis.rectangle"
                               : "xmark.bin")?
                .withTintColor(.dim, renderingMode: .alwaysOriginal)
            iv.contentMode = .scaleAspectFit
            return iv
        }()
        
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .dim
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.sizeToFit()
            return label
        }()
        
        self.addSubview(emptyView)
        emptyView.addSubviews(iconView, messageLabel)
        emptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(280.verticallyAdjusted)
            make.width.equalToSuperview()
        }
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(57)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
