//
//  DateComponents+.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/31.
//

import Foundation

extension DateComponents {
    
    static func convertTime(_ date: Date) -> Self {
        return .init(
            timeZone: .autoupdatingCurrent,
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: Calendar.current.component(.day, from: Date())
        )
    }
}
