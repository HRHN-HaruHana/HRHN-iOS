//
//  ReviewViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/27.
//

import Foundation

final class ReviewViewModel: ObservableObject {
    
    @Published var previousChallenge: Challenge?
    @Published var selectedEmoji: Emoji = .none
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        fetchPreviousChallenge()
    }
    
    func fetchPreviousChallenge() {
        let challenges = coreDataManager.getChallenges()
        if challenges.count > 0 {
            self.previousChallenge = challenges[0]
        }
    }
    
    func updateChallenge() {
        guard let previousChallenge else { return }
        let updatedChallenge = Challenge(
            id: previousChallenge.id,
            date: previousChallenge.date,
            content: previousChallenge.content,
            emoji: selectedEmoji
        )
        coreDataManager.updateChallenge(updatedChallenge)
    }
}
