//
//  EditChallenge.swift
//  HRHN
//
//  Created by 민채호 on 2023/02/28.
//

import Foundation

protocol EditChallenge {
    
    func getTodayChallenge() -> Challenge?
    func getPreviousChallenge() -> Challenge?
    func createChallenge(_ content: String)
    func updateChallengeContent(updatingChallenge challenge: Challenge, content: String)
    func deleteTodayChallenge()
}

extension EditChallenge where Self: ObservableObject {
    
    func getTodayChallenge() -> Challenge? {
        let challenges = CoreDataManager.shared.getChallengeOf(Date())
        if challenges.count > 0 {
            return challenges[0]
        } else {
            return nil
        }
    }
    
    func getPreviousChallenge() -> Challenge? {
        let challenges = CoreDataManager.shared.getChallenges()
        if challenges.count > 0 && challenges[0].emoji == .none {
            return challenges[0]
        } else {
            return nil
        }
    }
    
    func createChallenge(_ content: String) {
        CoreDataManager.shared.insertChallenge(Challenge(
            id: UUID(),
            date: Date(),
            content: content,
            emoji: .none)
        )
    }
    
    func updateChallengeContent(updatingChallenge challenge: Challenge, content: String) {
        let updatedChallenge = Challenge(
            id: challenge.id,
            date: challenge.date,
            content: content,
            emoji: challenge.emoji
        )
        CoreDataManager.shared.updateChallenge(updatedChallenge)
    }
    
    func deleteTodayChallenge() {
        CoreDataManager.shared.deleteChallenge(Date())
    }
}
