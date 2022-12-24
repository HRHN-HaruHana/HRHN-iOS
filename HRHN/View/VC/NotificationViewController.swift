//
//  NotificationViewController.swift : 알림 테스트용 뷰컨트롤러
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/25.
//  ref: https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app

import UIKit
import UserNotifications

final class NotificationViewController: UIViewController {
    
    let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationAuthorization()
        sendNotification(seconds: 10)
    }

    private func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        center.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Auth Error: ", error)
            }
        }
    }
    
    private func sendNotification(seconds: Double) {
        let content = UNMutableNotificationContent()
        content.title = "하루하나"
        content.body = "오늘의 챌린지를 등록하세요!"

        // MARK: Recurring date
        var dateComponents = DateComponents()
        dateComponents.hour = 06
        dateComponents.minute = 01
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
