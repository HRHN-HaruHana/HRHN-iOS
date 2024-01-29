//
//  ReviewViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/27.
//

import Combine
import UIKit

class ReviewViewModel: ObservableObject {
    
    enum Tab {
        case today
        case list
        case calendar
        case unknown
    }
    
    @Published var selectedEmoji: Emoji?
    @Published var challenge: Challenge?
    
    private let coreDataManager = CoreDataManager.shared
    let emojiDidTap = PassthroughSubject<Void, Never>()
    
    let previousTab: Tab
    
    init(from tab: Tab) {
        self.previousTab = tab
    }
    
    func updateChallenge() {
        guard let challenge else { return }
        guard let selectedEmoji else { return }
        let updatedChallenge = Challenge(
            id: challenge.id,
            date: challenge.date,
            content: challenge.content,
            emoji: selectedEmoji
        )
        coreDataManager.updateChallenge(updatedChallenge)
    }
    
    func deleteChallenge() {
        guard let challenge else { return }
        coreDataManager.deleteChallenge(challenge.date)
    }
    
    func didEmojiClicked() {
        updateChallenge()
        emojiDidTap.send()
    }
}
