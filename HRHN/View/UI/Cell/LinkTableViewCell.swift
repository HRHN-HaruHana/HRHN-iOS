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
        configuration.imageProperties.tintColor = item.type == .defaultItem ? .settingIconFill : .point
        contentConfiguration = configuration
        selectionStyle = .none
        
        switch item.type {
        case .alertTime:
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            timePicker.tintColor = .point
            timePicker.setValue(UIColor.point, forKeyPath: "textColor")
            timePicker.addTarget(self,
                                 action:#selector(timePickerdidChange(_:)),
                                 for: .valueChanged)
            accessoryView = timePicker
        case .alertToggle:
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(false, animated: true)
            switchView.tag = 1
            switchView.onTintColor = .point
            switchView.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
            accessoryView = switchView
        case .defaultItem:
            return
        }
        
    }
}

extension LinkTableViewCell {
    
    @objc func switchDidChange(_ sender: UISwitch) {
        // TODO: 스위치 제어
        // print("SWITCH : \(sender.isOn)")
    }
    
    @objc func timePickerdidChange(_ sender: UIDatePicker) {
        let timePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        // TODO: Date 제어
        // print(formatter.string(from: timePickerView.date))
    }
}
