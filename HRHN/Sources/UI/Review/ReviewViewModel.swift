//
//  ReviewViewModel.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/27.
//

import Foundation
import UIKit

class ReviewViewModel: ObservableObject {
    
    enum Tab {
        case today
        case list
        case calendar
        case storage
        case unknown
    }
    
    @Published var selectedEmoji: Emoji?
    @Published var challenge: Challenge?
    
    private let coreDataManager = CoreDataManager.shared
    
    private var todayViewController: TodayViewController?
    private var recordViewController: ListViewController?
    private var calendarPageViewController: CalendarPageViewController?
    
    let previousTab: Tab
    
    init(from rootViewController: UIViewController) {
        if let presentingViewController = rootViewController as? TodayViewController {
            self.todayViewController = presentingViewController
            self.previousTab = .today
        } else if let presentingViewController = rootViewController as? ListViewController {
            self.recordViewController = presentingViewController
            self.previousTab = .list
        } else if let presentingViewController = rootViewController as? CalendarPageViewController {
            self.calendarPageViewController = presentingViewController
            self.previousTab = .calendar
        } else {
            self.previousTab = .unknown
        }
    }
    
    func updateChallenge() {
        guard let challenge else { return }
        guard let selectedEmoji else { return }
        let updatedChallenge = Challenge(
            id: challenge.id,
            date: challenge.date,
            content: challenge.content,
            emoji: selectedEmoji
        )
        coreDataManager.updateChallenge(updatedChallenge)
    }
    
    func didEmojiClicked() {
        updateChallenge()
        todayViewController?.bottomSheetEmojiDidSelected()
        todayViewController?.addState()
        recordViewController?.bottomSheetDimmedViewDidTapped()
        calendarPageViewController?.bottomSheetDimmedViewDidTapped()
    }
}
