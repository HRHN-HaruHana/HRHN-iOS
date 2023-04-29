//
//  UICalendarPageViewController.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import UIKit
import SwiftUI

final class CalendarPageViewController: UIPageViewController {
    
    private let viewModel: CalendarPageViewModel
    
    lazy var bottomSheet: UIBottomSheet = {
        $0.bottomSheetHeight = 336
        $0.dimmedViewTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(bottomSheetDimmedViewDidTapped)
        )
        $0.bottomSheetPanGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(bottomSheetDidPanned)
        )
        return $0
    }(UIBottomSheet())

    lazy var bottomSheetContentView = ReviewView(viewModel: ReviewViewModel(from: self))
    
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
        bottomSheet.setLayout()
        bottomSheet.content = bottomSheetContentView
    }
}

extension CalendarPageViewController {
    
    private func setUI() {
        let hc = UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(
            calendarDate: Date(),
            presentingVC: self
        )))
        setViewControllers([hc], direction: .forward, animated: false)
        dataSource = self
        delegate = self
    }
}

extension CalendarPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentViewDate = hc.rootView.viewModel.calendarDate
        let lastMonth = viewModel.addMonths(-1, to: currentViewDate)
        return UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(
            calendarDate: lastMonth,
            presentingVC: self
        )))
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentViewDate = hc.rootView.viewModel.calendarDate
        if currentViewDate.isCurrentMonth() {
            return nil
        } else {
            let nextMonth = viewModel.addMonths(1, to: currentViewDate)
            return UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(
                calendarDate: nextMonth,
                presentingVC: self
            )))
        }
    }
}

extension CalendarPageViewController {
    
    @objc private func bottomSheetDidPanned(sender: UIPanGestureRecognizer) {
        bottomSheet.panGestureHandler(sender: sender)
    }
    
    @objc func bottomSheetDimmedViewDidTapped() {
        bottomSheet.dismissBottomSheet()
        viewModel.fetchHostingController(self: self)
    }
    
    func goToCurrentMonth() {
        let hc = UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(
            calendarDate: Date(),
            presentingVC: self
        )))
        setViewControllers([hc], direction: .forward, animated: true)
    }
}
