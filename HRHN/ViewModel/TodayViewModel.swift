//
//  TodayViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/25.
//

import Foundation



class TodayViewModel {
    
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
}
