//
//  RecordViewController.swift
//  HRHN
//
//  Created by 민채호 on 2023/04/14.
//

import UIKit

final class RecordViewController: UIViewController {
    
    private let calendarViewController = CalendarPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private let listViewController = ListViewController(with: ListViewModel())
    
    private lazy var viewModeBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "calendar"),
        style: .plain,
        target: self,
        action: #selector(viewModeBarButtonDidTap)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        showCalendarView()
    }
}

extension RecordViewController {
    private func showCalendarView() {
        listViewController.willMove(toParent: nil)
        listViewController.view.removeFromSuperview()
        listViewController.removeFromParent()
        
        addChild(calendarViewController)
        view.addSubview(calendarViewController.view)
        calendarViewController.didMove(toParent: self)
    }
    
    private func showListView() {
        calendarViewController.willMove(toParent: nil)
        calendarViewController.view.removeFromSuperview()
        calendarViewController.removeFromParent()
        
        addChild(listViewController)
        view.addSubview(listViewController.view)
        listViewController.didMove(toParent: self)
    }
}

extension RecordViewController: CustomNavBar {
    private func setNavigationBar() {
        setNavigationBarAppLogo()
        setNavigationBarBackButton()
        setNavigationBarRightIconButton(systemName: "gearshape.fill", action: #selector(settingsDidTap))
        navigationItem.rightBarButtonItems?.append(viewModeBarButtonItem)
    }
    
    @objc private func viewModeBarButtonDidTap() {
        if let _ = self.children.first(where: { $0 is CalendarPageViewController }) as? CalendarPageViewController {
            showListView()
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "list.bullet")?.withRenderingMode(.alwaysOriginal).withTintColor(.tintColor)
            
        } else if let _ = self.children.first(where: { $0 is ListViewController }) as? ListViewController {
            showCalendarView()
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysOriginal).withTintColor(.tintColor)
        }
    }
    
    @objc func settingsDidTap() {
        let settingVC = SettingViewController(viewModel: SettingViewModel())
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}
