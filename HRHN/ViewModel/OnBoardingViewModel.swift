//
//  OnBoardingViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/30.
//

import UIKit

final class OnBoardingViewModel {
    
    private let center = UNUserNotificationCenter.current()
    
    init(){}
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        center.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Auth Error: ", error)
            }
        }
    }
    
    func setOnBoarded(){
        UserDefaults.hasOnBoarded = true
        if UserDefaults.isNotiAllowed {
            setNotification(time: UserDefaults.notiTime ?? "09:00")
        }
    }
    
    func setNotiTime(with time: String){
        self.setNotiEnabled()
        UserDefaults.notiTime = time
    }
    
    func setNotiEnabled() {
        UserDefaults.isNotiAllowed = true
        setNotification(time: UserDefaults.notiTime ?? "09:00")
    }
    
    func setNotiDisabled() {
        UserDefaults.isNotiAllowed = false
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

}
