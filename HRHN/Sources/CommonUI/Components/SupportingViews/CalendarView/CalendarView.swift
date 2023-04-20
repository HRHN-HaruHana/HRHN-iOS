//
//  CalendarView.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import SwiftUI

struct CalendarView: View {
    
    let viewModel: CalendarViewModel
    
    private enum calendarViewCGFloat {
        static let margin: CGFloat =  20.verticallyAdjusted
        static let mediumVerticalSpacing: CGFloat = 20.verticallyAdjusted
        static let smallVerticalSpaicng: CGFloat = 10.verticallyAdjusted
        static let calendarEmojiSize: CGFloat = 30.verticallyAdjusted
        static let calendarButtonMargin: CGFloat = 10.verticallyAdjusted
        static let dayButtonSpacing: CGFloat = 5.verticallyAdjusted
    }
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            monthLabel(viewModel.calendarDate.monthName)
                .padding(.bottom, calendarViewCGFloat.mediumVerticalSpacing)
            weekLabels
                .padding(.bottom, calendarViewCGFloat.smallVerticalSpaicng)
            calendar
            Spacer()
            challengeCell
            Spacer()
        }
        .padding(calendarViewCGFloat.margin)
        .onAppear {
            if viewModel.selectedDay == nil {
                viewModel.setInitialSelectedDayAndChallenge()
            }
            viewModel.fetchChallengeCell()
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
            let emptyDayCount = viewModel.daysInMonth[0].weekdayNumber() - 1
            if emptyDayCount != 0 {
                ForEach(1...emptyDayCount, id: \.self) { _ in
                    emptyDay
                }
            }
            ForEach(viewModel.daysInMonth, id: \.self) { date in
                dayButton(date: date)
            }
        }
    }
    
    @ViewBuilder
    private func dayButton(date: Date) -> some View {
        let challenge = CoreDataManager.shared.getChallengeOf(date).first
        
        Button {
            viewModel.selectedDay = date
            viewModel.selectedChallenge = challenge
        } label: {
            VStack(spacing: calendarViewCGFloat.dayButtonSpacing) {
                if let challenge {
                    Image(challenge.emoji.rawValue)
                        .resizable()
                        .frame(width: calendarViewCGFloat.calendarEmojiSize, height: calendarViewCGFloat.calendarEmojiSize)
                } else {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: calendarViewCGFloat.calendarEmojiSize, height: calendarViewCGFloat.calendarEmojiSize)
                }
                Text("\(date.day)")
                    .font(.system(size: 13))
                    .foregroundColor(viewModel.isSelectedDay(date) ? .whiteLabel : Color(uiColor: .label))
            }
            .padding(.vertical, calendarViewCGFloat.calendarButtonMargin)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(viewModel.isSelectedDay(date) ? .dim : .clear)
            }
        }
    }
    
    @ViewBuilder
    private var emptyDay: some View {
        VStack(spacing: calendarViewCGFloat.dayButtonSpacing) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: calendarViewCGFloat.calendarEmojiSize, height: calendarViewCGFloat.calendarEmojiSize)
            Text("0")
                .font(.system(size: 13))
        }
        .padding(.vertical, calendarViewCGFloat.calendarButtonMargin)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 8)
        }
        .opacity(0)
    }
    
    @ViewBuilder
    private var challengeCell: some View {
        if let selectedChallenge = viewModel.selectedChallenge {
            Text("\(selectedChallenge.content) \(Image(Assets.dot))")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(calendarViewCGFloat.margin)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.cellFill)
                }
        }
    }
}

// MARK: - Previews

struct CalendarView_Previews: PreviewProvider {
    static let date = Date()
    
    static var previews: some View {
        CalendarView(viewModel: CalendarViewModel(calendarDate: date))
    }
}
