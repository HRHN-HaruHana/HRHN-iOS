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
    
    func goToCurrentMonth() {
        let hc = UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(
            calendarDate: Date(),
            presentingVC: self
        )))
        setViewControllers([hc], direction: .forward, animated: true)
    }
}
