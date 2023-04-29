//
//  CalendarViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2023/04/20.
//

import Foundation

final class CalendarViewModel: ObservableObject {
    
    let calendarDate: Date
    let presentingVC: CalendarPageViewController
    
    @Published var selectedDay: Date?
    @Published var selectedChallenge: Challenge?
    @Published var selectedDayState: SelectedDayState = .undefined
    
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
    
    enum SelectedDayState {
        case today, currentMonth, otherMonth, undefined
    }
    
    init(calendarDate: Date, presentingVC: CalendarPageViewController) {
        self.calendarDate = calendarDate
        self.presentingVC = presentingVC
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
    
    func fetchSelectedChallenge() {
        guard let selectedDay else { return }
        selectedChallenge = CoreDataManager.shared.getChallengeOf(selectedDay).first
    }
    
    func fetchSelectedDayState() {
        guard let selectedDay else { return }
        if selectedDay.isToday() {
            selectedDayState = .today
        } else if selectedDay.isCurrentMonth() {
            selectedDayState = .currentMonth
        } else {
            selectedDayState = .otherMonth
        }
    }
    
    func isSelectedDay(_ date: Date) -> Bool {
        guard let selectedDay else { return false }
        if date.year == selectedDay.year && date.month == selectedDay.month && date.day == selectedDay.day {
            return true
        } else {
            return false
        }
    }
    
    func goToCurrentMonth() {
        presentingVC.goToCurrentMonth()
    }
    
    func goToToday() {
        selectedDay = Date()
    }
    
    func presentBottomSheet() {
        presentingVC.bottomSheetContentView.viewModel?.challenge = selectedChallenge
        presentingVC.bottomSheet.presentBottomSheet()
    }
}
