//
//  CalendarView.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import SwiftUI

struct CalendarView :View {
    @State var monthDate: Date
    @State private var selectedDay: Date?
    @State private var selectedChallenge: Challenge?
    
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: monthDate) ?? 1..<29
        return range.map { day in
            var components = DateComponents()
            components.year = calendar.component(.year, from: monthDate)
            components.month = calendar.component(.month, from: monthDate)
            components.day = day
            return calendar.date(from: components) ?? Date()
        }
    }
    
    init(monthDate: Date) {
        self._monthDate = State(initialValue: monthDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            monthLabel(monthDate.monthName)
            weekLabels
                .padding(.top, 20.verticallyAdjusted)
                .padding(.bottom, 10.verticallyAdjusted)
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7),
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
            if let selectedChallenge {
                Text("\(selectedChallenge.content) \(Image(Assets.dot))")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(20.verticallyAdjusted)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.cellFill)
                    }
            }
            Spacer()
        }
        .padding(20.verticallyAdjusted)
        .onAppear {
            if isCurrentMonth() {
                selectedDay = Date()
            } else {
                selectedDay = daysInMonth[0]
                let firstDayChallenge = CoreDataManager.shared.getChallengeOf(daysInMonth[0])
                guard firstDayChallenge.count > 0 else { return }
                selectedChallenge = firstDayChallenge[0]
            }
        }
    }
}

// MARK: - ViewBuilders

extension CalendarView {
    
    @ViewBuilder
    private func monthLabel(_ month: String) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 3) {
            Text(month)
                .font(.system(size: 40.verticallyAdjusted))
                .fontWeight(.bold)
            Image(Assets.dot)
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
        HStack(spacing: 0) {
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
    private func dayButton(date: Date) -> some View {
        let challenge = CoreDataManager.shared.getChallengeOf(date)
        
        Button {
            selectedDay = date
            if challenge.count > 0 {
                selectedChallenge = challenge[0]
            } else {
                selectedChallenge = nil
            }
        } label: {
            VStack(spacing: 5.verticallyAdjusted) {
                if challenge.count > 0 {
                    Image(challenge[0].emoji.rawValue)
                        .resizable()
                        .frame(width: 30.verticallyAdjusted, height: 30.verticallyAdjusted)
                } else {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 30.verticallyAdjusted, height: 30.verticallyAdjusted)
                }
                Text("\(date.day)")
                    .font(.system(size: 13))
                    .foregroundColor(isSelectedDay(date) ? .whiteLabel : Color(uiColor: .label))
            }
            .padding(.vertical, 10.verticallyAdjusted)
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
                .frame(width: 30.verticallyAdjusted, height: 30.verticallyAdjusted)
            Text("0")
                .font(.system(size: 13))
        }
        .padding(.vertical, 10.verticallyAdjusted)
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
        if date.year == selectedDay.year && date.month == selectedDay.month && date.day == selectedDay.day {
            return true
        } else {
            return false
        }
    }
    
    private func isCurrentMonth() -> Bool {
        let today = Date()
        if today.year == monthDate.year && today.month == monthDate.month {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Previews

struct CalendarView_Previews: PreviewProvider {
    static let date = Date()
    
    static var previews: some View {
        CalendarView(monthDate: date)
    }
}
