//
//  SampleViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/23.
//

import UIKit

final class ListViewModel {
    
    @Published var challenges: [Challenge] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    func fetchPreviousChallenges() {
        let challenges = self.coreDataManager.getChallenges().filter { (challenge: Challenge) -> Bool in
            let current = Calendar.current
            return !current.isDateInToday(challenge.date)
        }
        self.challenges = challenges
    }
}
