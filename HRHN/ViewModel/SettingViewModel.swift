//
//  SettingViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/28.
//

import Foundation
import UserNotifications

final class SettingViewModel: ObservableObject {

    private let center = UNUserNotificationCenter.current()

    var isNotiAllowed: Observable<Bool> = Observable(UserDefaults.isNotiAllowed)
    var notiTime: Observable<String> = Observable(UserDefaults.notiTime ?? "09:00")
    
    init() {
        
    }

}
