//
//  StorageCellView.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//

import SwiftUI

struct StorageCellView: View {
    
    var item: StoredItem
    
    var body: some View {
        HStack(spacing: 20) {
            Text(item.content)
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(.cellLabel)
                .frame(minHeight: 82.5)
            VStack(alignment: .center) {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.secondary)
                    .frame(width: 15, height: 15)
            }
        }
        .padding(20)
        .background(Color.cellFill)
        .cornerRadius(16)
    }
}
