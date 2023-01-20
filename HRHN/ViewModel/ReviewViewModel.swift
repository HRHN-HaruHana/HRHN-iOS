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
        case addTab
        case recordTab
    }
    
    @Published var selectedEmoji: Emoji
    
    private let coreDataManager = CoreDataManager.shared
    private let navigationController: UINavigationController?
    
    let challenge: Challenge
    let previousTab: Tab
    
    init(from previousTab: Tab, challenge: Challenge, navigationController: UINavigationController?) {
        self.previousTab = previousTab
        self.challenge = challenge
        self.navigationController = navigationController
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
    
    func navigate() {
        switch previousTab {
        case .addTab:
            navigationController?.pushViewController(AddViewController(viewModel: AddViewModel()), animated: true)
        case .recordTab:
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
