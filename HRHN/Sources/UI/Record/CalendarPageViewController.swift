//
//  UICalendarPageViewController.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import UIKit
import SwiftUI

final class CalendarPageViewController: UIPageViewController {
    
    private let hc = UIHostingController(rootView: CalendarView(date: Date()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
    }
}

extension CalendarPageViewController: CustomNavBar {
    private func setNavigationBar() {
        setNavigationBarAppLogo()
        setNavigationBarBackButton()
        setNavigationBarRightIconButton(systemName: "gearshape.fill", action: #selector(settingsDidTap))
    }
    
    @objc func settingsDidTap(_ sender: UIButton) {
        let settingVC = SettingViewController(viewModel: SettingViewModel())
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}

extension CalendarPageViewController {
    
    private func setUI() {
        setViewControllers([hc], direction: .forward, animated: false)
        dataSource = self
        delegate = self
    }
}

extension CalendarPageViewController: UIPageViewControllerDelegate {
    
    private func addMonths(_ months: Int, to date: Date) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: date) ?? Date()
    }
}

extension CalendarPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentViewDate = hc.rootView.date
        let lastMonth = addMonths(-1, to: currentViewDate)
        return UIHostingController(rootView: CalendarView(date: lastMonth))
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentViewDate = hc.rootView.date
        let nextMonth = addMonths(1, to: currentViewDate)
        return UIHostingController(rootView: CalendarView(date: nextMonth))
    }
}
