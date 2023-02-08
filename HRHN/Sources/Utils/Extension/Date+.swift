//
//  Date+.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/23.
//

import Foundation

extension Date {
    /**
     # formatted
     - Note: 입력한 Format으로 변형한 String 반환
     - Parameters:
     - format: 변형하고자 하는 String타입의 Format (ex : "yyyy/MM/dd")
     - Returns: DateFormatter로 변형한 String
     */
    public func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
        return formatter.string(from: self)
    }
    
    func currentTimeZoneDate() -> Date {
        return Calendar.current.date(from: DateComponents.convertTime(Date())) ?? Date()
    }
}

/* Localization */
extension Date {
    
    public func localizedFullDate(_ locale: String) -> String {
        let formatter = DateFormatter()
        if locale == "ko" {
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.setLocalizedDateFormatFromTemplate("YYYY.MM.dd")
        } else {
            formatter.locale = Locale(identifier: "en_US")
            formatter.setLocalizedDateFormatFromTemplate("MM.dd.YYYY")
        }
        return formatter.string(from: Date())
    }
    
}
