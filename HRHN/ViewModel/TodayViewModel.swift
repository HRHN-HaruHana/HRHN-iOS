//
//  TodayViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/25.
//

import UIKit

final class TodayViewModel {
    
    var todayChallenge: Observable<String?> = Observable(nil)
    
    private var coreDataManager = CoreDataManager.shared
    private let center = UNUserNotificationCenter.current()
    
    init(){}
    
    func fetchTodayChallenge() {
        let challenges = self.coreDataManager.getChallengeOf(Date())
        if challenges.count > 0 {
            self.todayChallenge = Observable(challenges[0].content)
        } else {
            self.todayChallenge = Observable(nil)
        }
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        center.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Auth Error: ", error)
            }
        }
    }
    
    func isTodayChallengeExist() -> Bool {
        if todayChallenge.value == nil {
            return false
        } else {
            return true
        }
    }
    
    func addButtonDidTap(navigationController: UINavigationController?) {
        let challenges = coreDataManager.getChallenges()
        if challenges.count > 0 && challenges[0].emoji == .none {
            let reviewVC = ReviewViewController(viewModel: ReviewViewModel(
                from: .addTab,
                challenge: challenges[0],
                navigationController: navigationController
            ))
            reviewVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(reviewVC, animated: true)
        } else {
            let addVC = AddViewController(viewModel: AddViewModel())
            addVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(addVC, animated: true)
        }
    }
}
