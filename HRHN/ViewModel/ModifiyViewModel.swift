//
//  ModifiyViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/30.
//

import Foundation
import WidgetKit

final class ModifyViewModel: ObservableObject {
    
    enum Mode {
        case add, modify
    }
    
    @Published var currentChallenge: Challenge?
    
    private let coreDataManager = CoreDataManager.shared
    private let widgetCenter = WidgetCenter.shared
    
    let mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        if mode == .modify {
            fetchCurrentChallenge()
        }
    }
    
    func fetchCurrentChallenge() {
        let challenges = coreDataManager.getChallengeOf(Date())
        if challenges.count > 0 {
            currentChallenge = challenges[0]
        }
    }
    
    func updateChallenge(_ content: String) {
        guard let currentChallenge else { return }
        let updatedChallenge = Challenge(
            id: currentChallenge.id,
            date: currentChallenge.date,
            content: content,
            emoji: currentChallenge.emoji
        )
        coreDataManager.updateChallenge(updatedChallenge)
    }
    
    func updateWidget() {
        widgetCenter.reloadAllTimelines()
    }
}
