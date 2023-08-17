//
//  EditViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2023/06/13.
//

import Combine
import Foundation

final class EditViewModel: ObservableObject {
    
    @Published var selectedChallenge: Challenge?
    @Published var selectedDate: Date?
    
    private let coreDataManager = CoreDataManager.shared
    
    func reserveChallenge(_ content: String) {
        guard let selectedDate else { return }
        if let selectedChallenge {
            coreDataManager.updateChallenge(Challenge(
                id: selectedChallenge.id,
                date: selectedChallenge.date,
                content: content,
                emoji: selectedChallenge.emoji)
            )
        } else {
            coreDataManager.insertChallenge(Challenge(
                id: UUID(),
                date: selectedDate,
                content: content,
                emoji: .none)
            )
        }
    }
    
    func deleteChallenge() {
        guard let selectedDate else { return }
        coreDataManager.deleteChallenge(selectedDate)
    }
}
