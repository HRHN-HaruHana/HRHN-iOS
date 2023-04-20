//
//  CalendarViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2023/04/20.
//

import Foundation

final class CalendarViewModel: ObservableObject {
    
    let calendarDate: Date
    @Published var selectedDay: Date?
    @Published var selectedChallenge: Challenge?
    
    var daysInMonth: [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: calendarDate) ?? 1..<29
        return range.map { day in
            var components = DateComponents()
            components.year = calendar.component(.year, from: calendarDate)
            components.month = calendar.component(.month, from: calendarDate)
            components.day = day
            return calendar.date(from: components) ?? Date()
        }
    }
    
    init(calendarDate: Date) {
        self.calendarDate = calendarDate
    }
}

extension CalendarViewModel {
    
    func setInitialSelectedDayAndChallenge() {
        if calendarDate.isCurrentMonth() {
            let today = Date()
            let todayChallenge = CoreDataManager.shared.getChallengeOf(today).first
            selectedDay = today
            selectedChallenge = todayChallenge
        } else {
            let firstDay = daysInMonth[0]
            let firstDayChallenge = CoreDataManager.shared.getChallengeOf(firstDay).first
            selectedDay = firstDay
            selectedChallenge = firstDayChallenge
        }
    }
    
    func fetchChallengeCell() {
        guard let selectedDay else { return }
        selectedChallenge = CoreDataManager.shared.getChallengeOf(selectedDay).first
    }
    
    func isSelectedDay(_ date: Date) -> Bool {
        guard let selectedDay else { return false }
        if date.year == selectedDay.year && date.month == selectedDay.month && date.day == selectedDay.day {
            return true
        } else {
            return false
        }
    }
}
