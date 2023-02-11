//
//  SampleModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//

import Foundation

enum Emoji: String, Codable {
    case success = "Success"
    case tried = "Tried"
    case fail = "Fail"
    case none = "none"
    case red = "red"
    case yellow = "yellow"
    case green = "green"
    case skyblue = "skyblue"
    case blue = "blue"
    case purple = "purple"
    
    var name: String {
        switch self {
        case .success, .red: return "Success"
        case .tried, .yellow, .green, .skyblue, .blue: return "Tried"
        case .fail, .purple: return "Fail"
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
