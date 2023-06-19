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
    
    func convertToCurrentTimeZone() -> Date {
        return Calendar.current.date(from: DateComponents.convertTime(self)) ?? Date()
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

/* Calendar */

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "US")
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    var dayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    /**
     # weekdayNumber
     오늘 요일을 반환합니다.
     - Note: 1 ~ 7은 일요일 ~ 토요일을 의미합니다. 즉 목요일일 경우, 5입니다.
     */
    func weekdayNumber() -> Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /**
     # isCurrentMonth
     Date가 이번달인지 아닌지를 반환합니다.
     */
    func isCurrentMonth() -> Bool {
        let today = Date()
        if today.year == self.year && today.month == self.month {
            return true
        } else {
            return false
        }
    }
    
    /**
     # isToday
     Date가 오늘인지 아닌지를 반환합니다.
     */
    func isToday() -> Bool {
        let today = Date()
        if today.year == self.year && today.month == self.month && today.day == self.day {
            return true
        } else {
            return false
        }
    }
    
    func isFuture() -> Bool {
        let today = Date()
        if self > today && !self.isToday() {
            return true
        } else {
            return false
        }
    }
    
    func isPast() -> Bool {
        let today = Date()
        if self < today && !self.isToday() {
            return true
        } else {
            return false
        }
    }
}
