//
//  AddViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/28.
//

import Foundation

final class AddViewModel: ObservableObject {
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {}
    
    func createChallenge(_ content: String) {
        coreDataManager.insertChallenge(Challenge(
            id: UUID(),
            date: Date(),
            content: content,
            emoji: .none)
        )
    }
}
