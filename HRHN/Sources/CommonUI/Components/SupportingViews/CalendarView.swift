//
//  CalendarView.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import SwiftUI

struct CalendarView :View {
    @State var date: Date
    @State private var selectedDay: Date?
    
    init(date: Date) {
        self._date = State(initialValue: date)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            monthLabel(date.monthName)
                .padding(.bottom, 20)
            weekLabels
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                GridRow {
                    dayButton(isEmpty: true)
                    dayButton(isEmpty: true)
                    dayButton(isEmpty: true)
                    dayButton(num: 1, emoji: .tried)
                    dayButton(num: 2, emoji: .success)
                    dayButton(num: 3, emoji: .tried)
                    dayButton(num: 4, emoji: .fail)
                }
                GridRow {
                    dayButton(num: 5, emoji: .success)
                    dayButton(num: 6, emoji: .tried)
                    dayButton(num: 7, emoji: .fail)
                    dayButton(num: 8, emoji: .tried)
                    dayButton(num: 9, emoji: .success)
                    dayButton(num: 10, emoji: .tried)
                    dayButton(num: 11, emoji: .fail)
                }
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
    }
}

// MARK: - ViewBuilders

extension CalendarView {
    @ViewBuilder
    private func monthLabel(_ month: String) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 3) {
            Text(month)
                .font(.system(size: 40))
                .fontWeight(.bold)
            Image("Dot")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func weekdayLabel(_ weekday: String) -> some View {
        Text(weekday)
            .font(.system(size: 15))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var weekLabels: some View {
        HStack {
            weekdayLabel("SUN")
            weekdayLabel("MON")
            weekdayLabel("TUE")
            weekdayLabel("WED")
            weekdayLabel("THU")
            weekdayLabel("FRI")
            weekdayLabel("SAT")
        }
    }
    
    @ViewBuilder
    private func dayButton(
        isEmpty: Bool = false,
        num: Int = 0,
        emoji: Emoji = .none
    ) -> some View {
        VStack(spacing: 5) {
            switch emoji {
            case .none:
                EmptyView()
                    .frame(width: 30, height: 30)
            default:
                Image(emoji.rawValue)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            Text("\(num)")
                .font(.system(size: 13))
                .foregroundColor(num == selectedDay?.day ? .whiteLabel : Color(uiColor: .label))
        }
        .opacity(isEmpty ? 0 : 1)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(num == selectedDay?.day ? .dim : .clear)
        }
    }
    
    @ViewBuilder
    private func ndayButton(
        isEmpty: Bool = false,
        date: Date
    ) -> some View {
        VStack(spacing: 5) {
//            Image(emoji.rawValue)
            Image("success")
                .resizable()
                .frame(width: 30, height: 30)
            Text("\(date.day)")
                .font(.system(size: 13))
        }
        .opacity(isEmpty ? 0 : 1)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.clear)
        }
    }
}

// MARK: - Calendar Methods

extension CalendarView {
    private func setCalendarMonth(year: Int, month: Int) {
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = 1
        Calendar.current.date(from: dateComponent)
    }
    
    private func makeCalendar() {
        
    }
    
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date) ?? 1..<29
        return range.map { day in
            var components = DateComponents()
            components.year = calendar.component(.year, from: date)
            components.month = calendar.component(.month, from: date)
            components.day = day
            return calendar.date(from: components) ?? Date()
        }
    }

    private func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - 임시 ViewModel

extension CalendarView {
    private func getChallenges() -> [Challenge] {
        let coreDataManager = CoreDataManager.shared
        let challenges = coreDataManager.getChallenges().filter { (challenge: Challenge) -> Bool in
            let current = Calendar.current
            return !current.isDateInToday(challenge.date)
        }
        return challenges
    }
}

// MARK: - Previews

struct CalendarView_Previews: PreviewProvider {
    static let date = Date()
    
    static var previews: some View {
        CalendarView(date: date)
    }
}
