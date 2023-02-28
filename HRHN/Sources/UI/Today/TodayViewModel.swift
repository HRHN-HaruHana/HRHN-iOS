//
//  TodayViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/25.
//

import UIKit
import WidgetKit

final class TodayViewModel: ObservableObject {
    
    @Published var todayChallenge: Challenge? = nil
    var previousChallenge: Challenge? = nil
    
    private let coreDataManager = CoreDataManager.shared
    private let widgetCenter = WidgetCenter.shared
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {}
    
    // MARK: - Challenge
    
    func fetchTodayChallenge() {
        let challenges = coreDataManager.getChallengeOf(Date())
        if challenges.count > 0 {
            todayChallenge = challenges[0]
        } else {
            todayChallenge = nil
        }
    }
    
    func fetchPreviousChallenge() {
        let challenges = coreDataManager.getChallenges()
        if challenges.count > 0 && challenges[0].emoji == .none {
            previousChallenge = challenges[0]
        } else {
            previousChallenge = nil
        }
    }
    
    func createChallenge(_ content: String) {
        coreDataManager.insertChallenge(Challenge(
            id: UUID(),
            date: Date(),
            content: content,
            emoji: .none)
        )
    }
    
    func updateChallenge(_ content: String) {
        guard let todayChallenge else { return }
        let updatedChallenge = Challenge(
            id: todayChallenge.id,
            date: todayChallenge.date,
            content: content,
            emoji: todayChallenge.emoji
        )
        coreDataManager.updateChallenge(updatedChallenge)
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
