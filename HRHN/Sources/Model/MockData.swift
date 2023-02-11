//
//  MockData.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/23.
//

import Foundation

extension Challenge {
    static let mock: [Challenge] = [
        Challenge(id: UUID(), date: Date(), content: "삶이 있는 한 희망은 있다 -키케로", emoji: Emoji.none),
        Challenge(id: UUID(), date: Date(), content: "삶이 있는 한 희망은 있다 -키케로", emoji: Emoji.red),
        Challenge(id: UUID(), date: Date(), content: "산다는것 그것은 치열한 전투이다. -로망로랑", emoji: Emoji.yellow),
        Challenge(id: UUID(), date: Date(), content: "The way to get started is to quit talking and begin doing. -Walt Disney", emoji: Emoji.green),
        Challenge(id: UUID(), date: Date(), content: "Life is what happens when you're busy making other plans. -John Lennon", emoji: Emoji.skyblue),
        Challenge(id: UUID(), date: Date(), content: "삶이 있는 한 희망은 있다 -키케로", emoji: Emoji.blue),
        Challenge(id: UUID(), date: Date(), content: "삶이 있는 한 희망은 있다 -키케로", emoji: Emoji.purple),
        Challenge(id: UUID(), date: Date(), content: "산다는것 그것은 치열한 전투이다. -로망로랑", emoji: Emoji.success)
    ]
}
