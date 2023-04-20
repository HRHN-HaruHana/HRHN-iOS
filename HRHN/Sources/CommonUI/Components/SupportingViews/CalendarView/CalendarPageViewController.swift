//
//  UICalendarPageViewController.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import UIKit
import SwiftUI

final class CalendarPageViewController: UIPageViewController {
    
    private let hc = UIHostingController(rootView: CalendarView(calendarDate: Date()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension CalendarPageViewController {
    
    private func setUI() {
        setViewControllers([hc], direction: .forward, animated: false)
        dataSource = self
        delegate = self
    }
}

extension CalendarPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentViewDate = hc.rootView.calendarDate
        let lastMonth = addMonths(-1, to: currentViewDate)
        return UIHostingController(rootView: CalendarView(calendarDate: lastMonth))
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentViewDate = hc.rootView.calendarDate
        if currentViewDate.isCurrentMonth() {
            return nil
        } else {
            let nextMonth = addMonths(1, to: currentViewDate)
            return UIHostingController(rootView: CalendarView(calendarDate: nextMonth))
        }
    }
}

extension CalendarPageViewController {
    
    private func addMonths(_ months: Int, to date: Date) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: date) ?? Date()
    }
}
