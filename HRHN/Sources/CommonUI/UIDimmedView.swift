//
//  UIDimmedView.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/01.
//

import UIKit

final class UIDimmedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        isUserInteractionEnabled = false
        backgroundColor = .black
        layer.opacity = 0
        isUserInteractionEnabled = false
    }
}
