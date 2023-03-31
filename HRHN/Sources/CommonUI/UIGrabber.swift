//
//  UIGrabber.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/01.
//

import UIKit

final class UIGrabber: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1)
        layer.cornerRadius = 3
        clipsToBounds = true
    }
}
