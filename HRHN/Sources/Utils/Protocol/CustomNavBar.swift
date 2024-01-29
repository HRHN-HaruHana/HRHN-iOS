//
//  CustomNavBar.swift
//  HRHN
//
//  Created by 민채호 on 2023/02/11.
//

import UIKit

protocol CustomNavBar {
    
    func setNavigationBarAppLogo()
    func setNavigationBarBackButton()
    func setNavigationBarRightIconButton(systemName: String, action: Selector)
    func setNavigationBarRightLabelButton(title: String, color: UIColor, action: Selector)
}

extension CustomNavBar where Self: UIViewController {
    
    func setNavigationBarAppLogo() {
        let leftBarTitle: UILabel = {
            $0.text = "1D1C"
            $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            $0.textColor = .navigationBarButton
            return $0
        }(UILabel())
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarTitle)
    }
    
    func setNavigationBarBackButton() {
        let backButton: UIBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        backButton.tintColor = .navigationBarButton
        navigationItem.backBarButtonItem = backButton
    }
    
    func setNavigationBarRightIconButton(systemName: String, action: Selector) {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: systemName),
            style: .plain,
            target: self,
            action: action
        )
        rightBarButton.tintColor = .navigationBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setNavigationBarRightLabelButton(title: String, color: UIColor, action: Selector) {
        let rightBarButton = UIBarButtonItem(
            title: I18N.deleteButtonTitle,
            style: .plain,
            target: self,
            action: action
        )
        rightBarButton.tintColor = color
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
