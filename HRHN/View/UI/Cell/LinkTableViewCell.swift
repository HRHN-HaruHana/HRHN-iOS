//
//  LinkTableViewCell.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/28.
//

import UIKit

class LinkTableViewCell: UITableViewCell {
    static let identifier = "LinkTableViewCell"
    
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        tintColor = .tintColor
    }
    
    func configureCell(with item: SettingItem){
        var configuration = defaultContentConfiguration() // valuetype
        configuration.text = item.text
        configuration.secondaryText = item.secondaryText
        configuration.secondaryTextProperties.color = .secondaryLabel
        configuration.image = UIImage(systemName: item.imageName)
        contentConfiguration = configuration
    }
    
}

extension UIImage {
   static func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
