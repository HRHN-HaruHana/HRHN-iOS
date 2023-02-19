//
//  View+.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/27.
//

import SwiftUI

extension View {
    func setBackgroundColor(_ color: Color) -> some View {
        ZStack {
            color.ignoresSafeArea()
            self
        }
    }
}
