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
                SettingItem(text: "알림", secondaryText: "하루 한 번, 알림을 드릴게요", type: .alertToggle, imageName: "bell.fill", link: nil, isOn: UserDefaults.isNotiAllowed, time: nil),
                SettingItem(text: "알림시간", secondaryText: nil, type: .alertTime, imageName: "clock.fill", link: nil, isOn: nil, time: UserDefaults.notiTime)
            ], header: "NOTIFICATION"),
            SettingSection(items: [
                SettingItem(text: "문의 및 지원", secondaryText: nil, type: .defaultItem, imageName: "phone.fill", link: "https://hrhn.notion.site/d56ff2386c464543bbeb20284e3f3469", isOn: nil, time: nil),
                SettingItem(text: "홈페이지", secondaryText: nil, type: .defaultItem, imageName: "globe", link: "https://hrhn.notion.site/f7ecd6dca58046b298ad8debfbcc762e", isOn: nil, time: nil),
                SettingItem(text: "오픈소스 라이선스", secondaryText: nil, type: .defaultItem, imageName: "chevron.left.forwardslash.chevron.right", link: "https://hrhn.notion.site/2dd3252ad190433392c58f77e975cb18", isOn: nil, time: nil)
            ], header: "SUPPORT")
        ]
    }
}

final class SettingViewModel: ObservableObject {

    private let center = UNUserNotificationCenter.current()
    var list: Observable<[SettingSection]> = Observable(SettingSection.generateData())
    
    init() {}

    func setNotAllowed(with: Bool) {
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
        content.title = "하루하나"
        content.body = "오늘의 챌린지를 등록하세요!"
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
        center.removeDeliveredNotifications(withIdentifiers: ["dailyAlert"])
    }

}
