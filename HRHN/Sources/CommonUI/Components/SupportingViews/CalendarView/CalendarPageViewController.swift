//
//  UICalendarPageViewController.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import Combine
import UIKit
import SwiftUI

final class CalendarPageViewController: UIPageViewController {
    
    private let viewModel: CalendarPageViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var bottomSheet: BottomSheetController = {
        $0.sheetWillDismiss = { [weak self] in
            self?.dismissBottomSheet()
        }
        return $0
    }(BottomSheetController(content: bottomSheetContentView))

    private let bottomSheetContentView = ReviewView(viewModel: ReviewViewModel(from: .calendar))
    
    init(viewModel: CalendarPageViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
}

extension CalendarPageViewController {
    
    private func setUI() {
        let hc = UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(
            calendarDate: Date()
        )))
        setViewControllers([hc], direction: .forward, animated: false)
        dataSource = self
        delegate = self
    }
    
    private func bind() {
        cancelBag.removeAll()
        if let hc = viewControllers?.first as? UIHostingController<CalendarView> {
            hc.rootView.willPresentBottomSheet
                .sink { [weak self] in
                    self?.presentBottomSheet()
                }
                .store(in: &cancelBag)
            hc.rootView.fetchBottomSheetContent
                .sink { [weak self] challenge in
                    self?.bottomSheetContentView.viewModel.challenge = challenge
                    self?.bottomSheetContentView.viewModel.selectedEmoji = challenge?.emoji
                }
                .store(in: &cancelBag)
            hc.rootView.goToCurrentMonth
                .sink{ [weak self] in
                    self?.goToCurrentMonth()
                }
                .store(in: &cancelBag)
        }
    }
}

extension CalendarPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentPageDate = hc.rootView.viewModel.calendarDate
        let lastMonth = viewModel.addMonths(-1, to: currentPageDate)
        return UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(calendarDate: lastMonth)))
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentViewDate = hc.rootView.viewModel.calendarDate
        if currentViewDate.isCurrentMonth() {
            return nil
        } else {
            let nextMonth = viewModel.addMonths(1, to: currentViewDate)
            return UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(calendarDate: nextMonth)))
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        bind()
    }
}

extension CalendarPageViewController {
    
    func goToCurrentMonth() {
        let hc = UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(calendarDate: Date())))
        setViewControllers([hc], direction: .forward, animated: true)
        bind()
    }
    
    private func presentBottomSheet() {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.dim()
        bottomSheet.modalPresentationStyle = .overFullScreen
        bottomSheet.modalTransitionStyle = .coverVertical
        present(bottomSheet, animated: true)
    }
    
    func dismissBottomSheet() {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.brighten()
        dismiss(animated: true)
        guard let hc = self.viewControllers?.first as? UIHostingController<CalendarView> else { return }
        hc.rootView.viewModel.fetchSelectedChallenge()
    }
}
