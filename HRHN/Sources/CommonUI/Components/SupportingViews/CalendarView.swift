//
//  CalendarView.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import SwiftUI

struct CalendarView :View {
    @State var date: Date
    @State private var selectedDay: Date? = Date()
    
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
    
    init(date: Date) {
        self._date = State(initialValue: date)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            monthLabel(date.monthName)
            weekLabels
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 7),
                spacing: 0
            ) {
                let emptyDayCount = daysInMonth[0].weekdayNumber() - 1
                if emptyDayCount != 0 {
                    ForEach(1...emptyDayCount, id: \.self) { _ in
                        emptyDay
                    }
                }
                ForEach(daysInMonth, id: \.self) { date in
                    dayButton(date: date)
                }
            }
            Spacer()
        }
        .padding(20)
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
    private func dayButton(date: Date, challenge: Challenge? = nil) -> some View {
        Button {
            selectedDay = date
        } label: {
            VStack(spacing: 5) {
                if let challenge {
                    Image(challenge.emoji.rawValue)
                        .resizable()
                        .frame(width: 30, height: 30)
                } else {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 30, height: 30)
                }
                Text("\(date.day)")
                    .font(.system(size: 13))
                    .foregroundColor(isSelectedDay(date) ? .whiteLabel : Color(uiColor: .label))
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(isSelectedDay(date) ? .dim : .clear)
            }
        }
    }
    
    @ViewBuilder
    private var emptyDay: some View {
        VStack(spacing: 5) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 30, height: 30)
            Text("0")
                .font(.system(size: 13))
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 8)
        }
        .opacity(0)
    }
}

// MARK: - Methods

extension CalendarView {
    private func isSelectedDay(_ date: Date) -> Bool {
        guard let selectedDay else { return false }
        let diff = Calendar.current.dateComponents([.year, .month, .day], from: date, to: selectedDay)
        if diff.year == 0 && diff.month == 0 && diff.day == 0 {
            return true
        } else {
            return false
        }
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
