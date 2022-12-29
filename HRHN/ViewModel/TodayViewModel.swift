//
//  TodayViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/25.
//

import UIKit

final class TodayViewModel {
    
    var todayChallenge: Observable<String?> = Observable(nil)
    
    private var coreDataManager = CoreDataManager.shared
    private let center = UNUserNotificationCenter.current()
    
    init(){}
    
    func fetchTodayChallenge() {
        let challenges = self.coreDataManager.getChallengeOf(Date())
        if challenges.count > 0 {
            self.todayChallenge = Observable(challenges[0].content)
        } else {
            self.todayChallenge = Observable(nil)
        }
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        center.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Auth Error: ", error)
            }
        }
    }
}
