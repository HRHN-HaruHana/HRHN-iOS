//
//  ReviewViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/27.
//

import Foundation

final class ReviewViewModel: ObservableObject {
    
    @Published var lastChallenge: Challenge?
    @Published var selectedEmoji: Emoji = .none
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        fetchLastChallenge()
    }
    
    func fetchLastChallenge() {
        let challenges = coreDataManager.getChallenges()
        if challenges.count > 0 && challenges[0].emoji == .none {
            self.lastChallenge = challenges[0]
        }
    }
    
    func fullWidthButtonDidTap() {
        
    }
}
