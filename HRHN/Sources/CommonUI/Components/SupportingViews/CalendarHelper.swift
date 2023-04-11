//
//  CalendarHelper.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import Foundation

class CalendarHelper {
    
}

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
    
    /**
     # weekdayNumber
     오늘 요일을 반환합니다.
     - Note: 1 ~ 7은 일요일 ~ 토요일을 의미합니다. 즉 목요일일 경우, 5입니다.
     */
    func weekdayNumber() -> Int {
        return Calendar.current.component(.weekday, from: self)
    }
}
