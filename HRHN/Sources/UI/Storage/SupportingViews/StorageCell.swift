//
//  StorageCell.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//

import UIKit
import SwiftUI

final class StorageCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        contentConfiguration = nil
    }

    func configure(with challenge: Challenge) {
        self.contentConfiguration = UIHostingConfiguration {
            StorageCellView(challenge: challenge)
        }
        .margins(.vertical, 10)
        backgroundColor = .clear
        selectionStyle = .none
    }

}
