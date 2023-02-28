//
//  ReviewViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/27.
//

import Foundation
import UIKit

final class ReviewViewModel: ObservableObject {
    
    enum Tab {
        case today
        case record
        case storage
        case unknown
    }
    
    @Published var selectedEmoji: Emoji
    
    private let coreDataManager = CoreDataManager.shared
    
    private var todayViewController: TodayViewController?
    private var recordViewController: RecordViewController?
    
    let challenge: Challenge
    let previousTab: Tab
    
    init(from rootViewController: UIViewController, challenge: Challenge) {
        if let presentingViewController = rootViewController as? TodayViewController {
            self.todayViewController = presentingViewController
            self.previousTab = .today
        } else if let presentingViewController = rootViewController as? RecordViewController {
            self.recordViewController = presentingViewController
            self.previousTab = .record
        } else {
            self.previousTab = .unknown
        }
        
        self.challenge = challenge
        self.selectedEmoji = challenge.emoji
    }
    
    func updateChallenge() {
        let updatedChallenge = Challenge(
            id: challenge.id,
            date: challenge.date,
            content: challenge.content,
            emoji: selectedEmoji
        )
        coreDataManager.updateChallenge(updatedChallenge)
    }
    
    func didEmojiClicked() {
        todayViewController?.dismissBottomSheet()
        todayViewController?.addState()
    }
}
