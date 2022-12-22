//
//  SampleModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//

import Foundation

enum Emoji: String, Codable {
    case red = "pink"
    case yellow = "yellow"
    case green = "green"
    case skyblue = "skyblue"
    case blue = "blue"
    case purple = "purple"
    case none = "none"
}

struct Challenge {
    let id: UUID
    let date: Date
    let content: String
    let emoji: Emoji
}
