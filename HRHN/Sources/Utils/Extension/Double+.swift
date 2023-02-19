//
//  Double+.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/21.
//

import UIKit

extension Double {
    var horizontallyAdjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 390
        return CGFloat(self) * ratio
    }
    
    var verticallyAdjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 844
        return self * ratio
    }
}

