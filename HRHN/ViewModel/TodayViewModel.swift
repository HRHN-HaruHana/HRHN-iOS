//
//  TodayViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/25.
//

import Foundation

final class TodayViewModel {
    
    var todayChallenge: Observable<String?> = Observable(nil)
    
    private var coreDataManager = CoreDataManager.shared
    
    init(){}
    
    func fetchTodayChallenge() {
        let challenges = self.coreDataManager.getChallengeOf(Date())
        if challenges.count > 0 {
            self.todayChallenge = Observable(challenges[0].content)
        } else {
            self.todayChallenge = Observable(nil)
        }
    }
    
    func isPreviousChallengeExist() -> Bool {
        let challenges = coreDataManager.getChallenges()
        if challenges.count > 0 && challenges[0].emoji == .none {
            return true
        } else {
            return false
        }
    }
}
