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
    @State private var selectedDayState: DayState?
    let willPresentReviewSheet = PassthroughSubject<Void, Never>()
    let willPresentReserveSheet = PassthroughSubject<Void, Never>()
    let fetchReviewSheetContent = PassthroughSubject<Challenge?, Never>()
    let fetchReserveSheetContent = PassthroughSubject<(Date?, Challenge?), Never>()
    let goToCurrentMonthFromPast = PassthroughSubject<Void, Never>()
    let goToCurrentMonthFromFuture = PassthroughSubject<Void, Never>()
    
    private enum DayState {
        case noChallengePast, hasChallengePast
        case noChallengeToday, hasChallengeToday
        case noChallengeFuture, hasChallengeFuture
    }
    
    private enum CalendarViewCGFloat {
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
            .padding(.bottom, CalendarViewCGFloat.mediumVerticalSpacing)
            weekLabels
                .padding(.bottom, CalendarViewCGFloat.smallVerticalSpaicng)
            calendar
            Spacer()
            switch selectedDayState {
            case .hasChallengePast, .hasChallengeToday, .hasChallengeFuture:
                challengeCell
                Spacer()
            case .noChallengeFuture:
                reserveChallengeButton
                    .frame(maxWidth: .infinity, alignment: .trailing)
            default:
                EmptyView()
            }
        }
        .padding(CalendarViewCGFloat.margin)
        .onAppear {
            if viewModel.selectedDay == nil {
                viewModel.setInitialSelectedDayAndChallenge()
            }
            viewModel.fetchSelectedChallenge()
            setSelectedDayState(viewModel.selectedDay)
        }
        .onChange(of: viewModel.selectedDay) { selectedDay in
            viewModel.fetchSelectedChallenge()
            viewModel.fetchSelectedDayState()
            setSelectedDayState(selectedDay)
        }
    }
}

// MARK: - Methods

extension CalendarView {
    
    private func setSelectedDayState(_ selectedDay: Date?) {
        guard let selectedDay else { return }
        if selectedDay.isPast() {
            if viewModel.selectedChallenge == nil {
                selectedDayState = .noChallengePast
            } else {
                selectedDayState = .hasChallengePast
            }
        } else if selectedDay.isFuture() {
            if viewModel.selectedChallenge == nil {
                selectedDayState = .noChallengeFuture
            } else {
                selectedDayState = .hasChallengeFuture
            }
        } else if selectedDay.isToday() {
            if viewModel.selectedChallenge == nil {
                selectedDayState = .noChallengeToday
            } else {
                selectedDayState = .hasChallengeToday
            }
        }
    }
    
    private func dayState(date: Date, challenge: Challenge?) -> DayState {
        if date.isPast() {
            if challenge == nil {
                return .noChallengePast
            } else {
                return .hasChallengePast
            }
        } else if date.isFuture() {
            if challenge == nil {
                return .noChallengeFuture
            } else {
                return .hasChallengeFuture
            }
        } else {
            if challenge == nil {
                return .noChallengeToday
            } else {
                return .hasChallengeToday
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
    private var todayButton: some View {
        switch viewModel.selectedDayState {
        case .currentMonth:
            Button {
                viewModel.goToToday()
            } label: {
                todayButtonLabel
            }
        case .pastMonth:
            Button {
                goToCurrentMonthFromPast.send()
            } label: {
                todayButtonLabel
            }
        case .futureMonth:
            Button {
                goToCurrentMonthFromFuture.send()
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
            VStack(spacing: CalendarViewCGFloat.dayButtonSpacing) {
                if let challenge {
                    Image(challenge.emoji.rawValue)
                        .resizable()
                        .frame(width: CalendarViewCGFloat.calendarEmojiSize, height: CalendarViewCGFloat.calendarEmojiSize)
                } else {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: CalendarViewCGFloat.calendarEmojiSize, height: CalendarViewCGFloat.calendarEmojiSize)
                }
                ZStack(alignment: .topTrailing) {
                    Text("\(date.day)")
                        .font(.system(size: 13))
                        .foregroundColor(dateLabelColor)
                    if (date.isFuture() && challenge != nil) {
                        // || (!date.isToday() && challenge?.emoji == Emoji.none)
                        Image("redDot")
                            .offset(x: 3, y: -3)
                    }
                    if dayState(date: date, challenge: challenge) == .hasChallengeFuture {
                        Image("redDot")
                            .offset(x: 3, y: -3)
                    }
                }
            }
            .padding(.vertical, CalendarViewCGFloat.calendarButtonMargin)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(viewModel.isSelectedDay(date) ? .dim : .clear)
            }
        }
    }
    
    @ViewBuilder
    private var emptyDay: some View {
        VStack(spacing: CalendarViewCGFloat.dayButtonSpacing) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: CalendarViewCGFloat.calendarEmojiSize, height: CalendarViewCGFloat.calendarEmojiSize)
            Text("0")
                .font(.system(size: 13))
        }
        .padding(.vertical, CalendarViewCGFloat.calendarButtonMargin)
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
                .padding(CalendarViewCGFloat.margin)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.cellFill)
                }
                .onTapGesture {
                    guard let selectedDay = viewModel.selectedDay else { return }
                    if selectedDay.isPast() {
                        willPresentReviewSheet.send()
                        fetchReviewSheetContent.send(viewModel.selectedChallenge)
                    } else if selectedDay.isFuture() {
                        willPresentReserveSheet.send()
                        fetchReserveSheetContent.send((viewModel.selectedDay, viewModel.selectedChallenge))
                    } else if selectedDay.isToday() {
                        willPresentReserveSheet.send()
                        fetchReserveSheetContent.send((viewModel.selectedDay, viewModel.selectedChallenge))
                    }
                }
        }
    }
    
    @ViewBuilder
    private var reserveChallengeButton: some View {
        Button {
            willPresentReserveSheet.send()
            fetchReserveSheetContent.send((viewModel.selectedDay, viewModel.selectedChallenge))
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "plus")
                Text("챌린지 예약")
            }
            .fontWeight(.medium)
            .foregroundColor(.point)
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.cellFill)
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
