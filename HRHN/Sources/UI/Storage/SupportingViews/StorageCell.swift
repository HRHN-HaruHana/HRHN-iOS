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

    func configure(with item: StoredItem) {
        self.contentConfiguration = UIHostingConfiguration {
            StorageCellView(item: item)
        }
        .margins(.vertical, 10)
        backgroundColor = .clear
        selectionStyle = .none
    }

}
