//
//  StorageViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//

import UIKit

final class StorageViewModel {
    var challenges: Observable<[Challenge]> = Observable([])
    
    private var coreDataManager = CoreDataManager.shared
    
    init(){}
    
    func fetchPreviousChallenges() {
        let challenges = self.coreDataManager.getChallenges().filter { (challenge: Challenge) -> Bool in
            let current = Calendar.current
            return !current.isDateInToday(challenge.date)
        }
        self.challenges = Observable(challenges)
    }
}

