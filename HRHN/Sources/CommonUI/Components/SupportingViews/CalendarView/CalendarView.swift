//
//  CalendarView.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import Combine
import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var viewModel: CalendarViewModel
    let willPresentBottomSheet = PassthroughSubject<Void, Never>()
    let fetchBottomSheetContent = PassthroughSubject<Challenge?, Never>()
    let goToCurrentMonth = PassthroughSubject<Void, Never>()
    
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
            HStack(alignment: .lastTextBaseline) {
                monthLabel(viewModel.calendarDate.monthName)
                todayButton
            }
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
            viewModel.fetchSelectedChallenge()
        }
        .onChange(of: viewModel.selectedDay) { _ in
            viewModel.fetchSelectedChallenge()
            viewModel.fetchSelectedDayState()
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
    private var todayButton: some View {
        switch viewModel.selectedDayState {
        case .currentMonth:
            Button {
                viewModel.goToToday()
            } label: {
                todayButtonLabel
            }
        case .otherMonth:
            Button {
                goToCurrentMonth.send()
            } label: {
                todayButtonLabel
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var todayButtonLabel: some View {
        HStack(spacing: 2) {
            Image(systemName: "arrow.uturn.forward")
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 1, height: 2)
                Text("Today")
            }
        }
        .font(.system(size: 15))
        .foregroundColor(.cellLabel)
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
        var dateLabelColor: Color {
            if viewModel.isSelectedDay(date) {
                return .reverseLabel
            } else if date.isFuture() {
                return Color(uiColor: .tertiaryLabel)
            } else {
                return Color(uiColor: .label)
            }
        }
        
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
                    .foregroundColor(dateLabelColor)
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
                .onTapGesture {
                    guard let selectedDay = viewModel.selectedDay else { return }
                    if !selectedDay.isToday() && !selectedDay.isFuture() {
                        willPresentBottomSheet.send()
                        fetchBottomSheetContent.send(viewModel.selectedChallenge)
                    }
                }
        }
    }
}

// MARK: - Previews

//struct CalendarView_Previews: PreviewProvider {
//    static let date = Date()
//
//    static var previews: some View {
//        CalendarView(viewModel: CalendarViewModel(calendarDate: date))
//    }
//}
