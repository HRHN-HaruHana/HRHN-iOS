//
//  SampleModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//

import Foundation

enum Emoji: String, Codable {
    case red = "red"
    case yellow = "yellow"
    case green = "green"
    case skyblue = "skyblue"
    case blue = "blue"
    case purple = "purple"
    case none = "none"
}

extension Emoji: Hashable, Equatable {
    public var hashValue: Int {
        switch self {
        case .red: return 0
        case .yellow: return 1
        case .green: return 2
        case .skyblue: return 3
        case .blue: return 4
        case .purple: return 5
        case .none: return 6
        }
    }
    
    public static func ==(lhs: Emoji, rhs: Emoji) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}


struct Challenge: Hashable, Equatable {
    let id: UUID
    let date: Date
    let content: String
    let emoji: Emoji
    
    init(id: UUID, date: Date, content: String, emoji: Emoji) {
        self.id = id
        self.date = date
        self.content = content
        self.emoji = emoji
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: Challenge, rhs: Challenge) -> Bool {
      lhs.id == rhs.id
    }
    
}
