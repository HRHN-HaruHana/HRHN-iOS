//
//  SampleModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//

import Foundation

enum Emoji: String, Codable {
    case success
    case tried
    case fail
    case none
    case red
    case yellow
    case green
    case skyblue
    case blue
    case purple
    
    var name: String {
        switch self {
        case .success, .red: return "success"
        case .tried, .yellow, .green, .skyblue, .blue: return "tried"
        case .fail, .purple: return "fail"
        case .none: return "none"
        }
    }
}

extension Emoji: Hashable, Equatable {
    public var hashValue: Int {
        switch self {
        case .success, .red: return 0
        case .tried, .yellow, .green, .skyblue, .blue: return 1
        case .fail, .purple: return 2
        case .none: return 3
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
