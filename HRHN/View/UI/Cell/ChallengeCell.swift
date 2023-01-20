//
//  ChallengeCell.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/24.
//

import UIKit
import SwiftUI

final class ChallengeCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        contentConfiguration = nil
    }

    func configure(with challenge: Challenge) {
        self.contentConfiguration = UIHostingConfiguration {
            ChallengeCellView(challenge: challenge)
        }
        .margins(.vertical, 10)
        backgroundColor = .clear
        selectionStyle = .none
    }
}
