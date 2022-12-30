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
    
    /**
     # getLocalizedDate
     - Note: Date를 시간대에 맞게 사용하기 위해 시간대 별 시차를 적용해주는 함수
     - Returns: 로컬라이징된 날짜
     */
    public func getLocalizedDate() -> Date {
        let timezone = TimeZone.autoupdatingCurrent
        let secondsFromGMT = timezone.secondsFromGMT(for: self)
        return self.addingTimeInterval(TimeInterval(secondsFromGMT))
    }
    
}
