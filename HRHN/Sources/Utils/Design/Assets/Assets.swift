//
//  Assets.swift
//  HRHN
//
//  Created by 민채호 on 2023/02/11.
//

import Foundation

struct Assets {
    
    enum TabbarIcons: String {
        case todaySelected = "Today_selected"
        case todayUnselected = "Today_unselected"
        case recordSelected = "Record_selected"
        case recordUnselected = "Record_unselected"
        case storageSelected = "Storage_selected"
        case storageUnselected = "Storage_unselected"
    }
    
    enum ReviewEmoji: String {
        case success = "Success"
        case tried = "Tried"
        case fail = "Fail"
    }
    
    static let dot = "Dot"
}
