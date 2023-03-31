//
//  TodayViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/25.
//

import UIKit
import WidgetKit

final class TodayViewModel: ObservableObject, EditChallenge {
    
    @Published var todayChallenge: Challenge? = nil
    var previousChallenge: Challenge? = nil
    
    private let coreDataManager = CoreDataManager.shared
    private let widgetCenter = WidgetCenter.shared
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        self.previousChallenge = getPreviousChallenge()
    }
    
    // MARK: - Notification
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Auth Error: ", error)
            }
        }
    }
    
    func removeOutdatedNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // MARK: - Widget
    
    func updateWidget() {
        widgetCenter.reloadAllTimelines()
    }
}
