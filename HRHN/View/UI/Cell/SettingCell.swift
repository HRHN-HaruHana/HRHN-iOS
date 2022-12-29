//
//  LinkTableViewCell.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/28.
//

import UIKit

class SettingCell: UITableViewCell {
    static let identifier = "LinkTableViewCell"
    var setAlertHandler: ((Bool) -> Void)?
    var setTimeHandler: ((String) -> Void)?
    
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.date(from: item.time ?? "09:00")
            timePicker.date = date ?? Date()
            accessoryView = timePicker
        case .alertToggle:
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(item.isOn ?? false, animated: true)
            switchView.tag = 1
            switchView.onTintColor = .point
            switchView.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
            accessoryView = switchView
        case .defaultItem:
            accessoryType = .disclosureIndicator
        }
        
    }
}

extension SettingCell {
    
    @objc func switchDidChange(_ sender: UISwitch) {
        self.setAlertHandler?(sender.isOn)
    }
    
    @objc func timePickerdidChange(_ sender: UIDatePicker) {
        let timePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.setTimeHandler?(formatter.string(from: timePickerView.date))
    }
}
