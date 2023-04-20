//
//  CalendarView.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import SwiftUI

struct CalendarView :View {
    @State var calendarDate: Date
    @State private var selectedDay: Date?
    @State private var selectedChallenge: Challenge?
    
    private var daysInMonth: [Date] {
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
    
    private enum Points {
        static let margin: CGFloat =  20.verticallyAdjusted
        static let mediumVerticalSpacing: CGFloat = 20.verticallyAdjusted
        static let smallVerticalSpaicng: CGFloat = 10.verticallyAdjusted
        static let calendarEmojiSize: CGFloat = 30.verticallyAdjusted
        static let calendarButtonMargin: CGFloat = 10.verticallyAdjusted
        static let dayButtonSpacing: CGFloat = 5.verticallyAdjusted
    }
    
    init(calendarDate: Date) {
        self._calendarDate = State(initialValue: calendarDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            monthLabel(calendarDate.monthName)
                .padding(.bottom, Points.mediumVerticalSpacing)
            weekLabels
                .padding(.bottom, Points.smallVerticalSpaicng)
            calendar
            Spacer()
            challengeCell
            Spacer()
        }
        .padding(Points.margin)
        .onAppear {
            if selectedDay == nil {
                setInitialSelectedDayAndChallenge()
            }
            fetchChallengeCell()
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
    private var goToTodayButton: some View {
        if !calendarDate.isCurrentMonth() {
            Button {
                let today = Date()
                calendarDate = today
                selectedDay = today
                fetchChallengeCell()
            } label: {
                HStack(alignment: .top, spacing: 2) {
                    Image(systemName: "arrow.uturn.right")
                    Text("Today")
                }
                .foregroundColor(.cellLabel)
            }
        }
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
    private func weekdayLabel(_ weekday: String) -> some View {
        Text(weekday)
            .font(.system(size: 15))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var calendar: some View {
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
    }
    
    @ViewBuilder
    private func dayButton(date: Date) -> some View {
        let challenge = CoreDataManager.shared.getChallengeOf(date).first
        
        Button {
            selectedDay = date
            selectedChallenge = challenge
        } label: {
            VStack(spacing: Points.dayButtonSpacing) {
                if let challenge {
                    Image(challenge.emoji.rawValue)
                        .resizable()
                        .frame(width: Points.calendarEmojiSize, height: Points.calendarEmojiSize)
                } else {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: Points.calendarEmojiSize, height: Points.calendarEmojiSize)
                }
                Text("\(date.day)")
                    .font(.system(size: 13))
                    .foregroundColor(isSelectedDay(date) ? .whiteLabel : Color(uiColor: .label))
            }
            .padding(.vertical, Points.calendarButtonMargin)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(isSelectedDay(date) ? .dim : .clear)
            }
        }
    }
    
    @ViewBuilder
    private var emptyDay: some View {
        VStack(spacing: Points.dayButtonSpacing) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: Points.calendarEmojiSize, height: Points.calendarEmojiSize)
            Text("0")
                .font(.system(size: 13))
        }
        .padding(.vertical, Points.calendarButtonMargin)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 8)
        }
        .opacity(0)
    }
    
    @ViewBuilder
    private var challengeCell: some View {
        if let selectedChallenge {
            Text("\(selectedChallenge.content) \(Image(Assets.dot))")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(Points.margin)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.cellFill)
                }
        }
    }
}

// MARK: - Methods

extension CalendarView {
    
    private func setInitialSelectedDayAndChallenge() {
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
    
    private func fetchChallengeCell() {
        guard let selectedDay else { return }
        selectedChallenge = CoreDataManager.shared.getChallengeOf(selectedDay).first
    }
    
    private func isSelectedDay(_ date: Date) -> Bool {
        guard let selectedDay else { return false }
        if date.year == selectedDay.year && date.month == selectedDay.month && date.day == selectedDay.day {
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
        CalendarView(calendarDate: date)
    }
}
