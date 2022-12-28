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
        
        var configuration = defaultContentConfiguration().updated(for: state) // valuetype
        configuration.text = "Hello World"
        configuration.image = UIImage(systemName: "bell")
        
        
//        if state.isHighlighted || state.isSelected {
//            configuration.textProperties.color = .red
//            configuration.imageProperties.tintColor = .yellow
//        }
//
        contentConfiguration = configuration
    }

}
