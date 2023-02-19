//
//  StoredItem.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//

import Foundation

struct StoredItem: Hashable, Equatable {
    let id: UUID
    let content: String
    
    init(id: UUID, content: String) {
        self.id = id
        self.content = content
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: StoredItem, rhs: StoredItem) -> Bool {
      lhs.id == rhs.id
    }
    
}
