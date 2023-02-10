//
//  CustomNavBar.swift
//  HRHN
//
//  Created by 민채호 on 2023/02/11.
//

import UIKit

protocol CustomNavBar {
    
    func setAppLogo()
    func setBackButton()
    func setRightIconButton(systemName: String, action: Selector)
}

extension CustomNavBar where Self: UIViewController {
    
    func setAppLogo() {
        let leftBarTitle: UILabel = {
            $0.text = "1D1C"
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            $0.textColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.4)
            return $0
        }(UILabel())
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarTitle)
    }
    
    func setBackButton() {
        let backButton: UIBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        backButton.tintColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.4)
        navigationItem.backBarButtonItem = backButton
    }
    
    func setRightIconButton(systemName: String, action: Selector) {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: systemName),
            style: .plain,
            target: self,
            action: action
        )
        rightBarButton.tintColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.4)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
