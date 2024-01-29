//
//  SettingViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/28.
//

import Foundation
import UserNotifications

enum SettingCellType: String {
    case defaultItem
    case alertToggle
    case alertTime
}

struct SettingItem {
    let text: String
    let secondaryText: String?
    let type: SettingCellType
    let imageName: String
    let link: String?
    let isOn: Bool?
    let time: String?
}

struct SettingSection {
    let items: [SettingItem]
    let header: String?
    
    static func generateData() -> [SettingSection] {
        return [
            SettingSection(items: [
                SettingItem(text: I18N.settingNoti1,
                            secondaryText: I18N.settingNoti2,
                            type: .alertToggle,
                            imageName: "Alarm",
                            link: nil,
                            isOn: UserDefaults.isNotiAllowed,
                            time: nil),
                SettingItem(text: I18N.settingNotiTime,
                            secondaryText: nil,
                            type: .alertTime,
                            imageName: "Time",
                            link: nil,
                            isOn: nil,
                            time: UserDefaults.notiTime)
            ], header: " "),
            SettingSection(items: [
                SettingItem(text: I18N.supportHelp,
                            secondaryText: nil,
                            type: .defaultItem,
                            imageName: "Contact",
                            link: "https://hrhn.notion.site/d56ff2386c464543bbeb20284e3f3469",
                            isOn: nil,
                            time: nil),
                SettingItem(text: I18N.supportPage,
                            secondaryText: nil,
                            type: .defaultItem,
                            imageName: "Website",
                            link: "https://hrhn.notion.site/f7ecd6dca58046b298ad8debfbcc762e",
                            isOn: nil,
                            time: nil),
                SettingItem(text: I18N.supportLicences,
                            secondaryText: nil,
                            type: .defaultItem,
                            imageName: "OpenSource",
                            link: "https://hrhn.notion.site/2dd3252ad190433392c58f77e975cb18",
                            isOn: nil,
                            time: nil)
            ], header: " ")
        ]
    }
}

final class SettingViewModel: ObservableObject {

    private let center = UNUserNotificationCenter.current()
    var list: Observable<[SettingSection]> = Observable(SettingSection.generateData())
    
    init() {}

    func setNotiAllowed(with: Bool) {
        UserDefaults.isNotiAllowed = with
        if UserDefaults.isNotiAllowed == false {
            removeNotification()
        } else {
            setNotification(time: UserDefaults.notiTime ?? "09:00")
        }
        list = Observable(SettingSection.generateData())
    }

    func setNotiTime(with time: String){
        UserDefaults.notiTime = time
        if UserDefaults.isNotiAllowed == true {
            setNotification(time: UserDefaults.notiTime ?? "09:00")
        }
        list = Observable(SettingSection.generateData())
    }
    
    private func setNotification(time: String) {
        let content = UNMutableNotificationContent()
        content.title = I18N.appName
        content.body = I18N.notiMsg
        let timeArr = time.components(separatedBy: ":")
        var dateComponents = DateComponents()
        dateComponents.hour = Int(timeArr[0])
        dateComponents.minute = Int(timeArr[1])
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyAlert",
                                            content: content,
                                            trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    private func removeNotification() {
        center.removeAllPendingNotificationRequests()
    }

}
