//
//  TabBarController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/20.
//

import UIKit

class TabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomHeightTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setUpTabBar()
    }
    
    private func setUI() {
        view.backgroundColor = .background
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 0.3)
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = UIColor.cellLabel
        tabBar.unselectedItemTintColor = UIColor.tertiaryLabel
    }
    
    private func setUpTabBar() {
        let todayVC = TodayViewController(viewModel: TodayViewModel())
        let firstTab = UINavigationController(rootViewController: todayVC)
        firstTab.tabBarItem = UITabBarItem(
            title: I18N.tabToday,
            image: UIImage(named: Assets.TabbarIcons.todayUnselected.rawValue),
            selectedImage: UIImage(named: Assets.TabbarIcons.todaySelected.rawValue)
        )
        firstTab.tabBarItem.imageInsets = .init(top: 0, left: 0, bottom: -6, right: 0)
        firstTab.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -5)
        
        let recordVC = UICalendarPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        let secondTab = UINavigationController(rootViewController: recordVC)
        secondTab.tabBarItem = UITabBarItem(
            title: I18N.tabRecord,
            image: UIImage(named: Assets.TabbarIcons.recordUnselected.rawValue),
            selectedImage: UIImage(named: Assets.TabbarIcons.recordSelected.rawValue)
        )
        secondTab.tabBarItem.imageInsets = .init(top: 0, left: 0, bottom: -6, right: 0)
        secondTab.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -5)
        
        let storageVC = UIViewController() // TODO: Change to StorageViewController
        let thirdTab = UINavigationController(rootViewController: storageVC)
        thirdTab.tabBarItem = UITabBarItem(
            title: I18N.tabStorage,
            image: UIImage(named: Assets.TabbarIcons.storageUnselected.rawValue),
            selectedImage: UIImage(named: Assets.TabbarIcons.storageSelected.rawValue)
        )
        thirdTab.tabBarItem.imageInsets = .init(top: 0, left: 0, bottom: -6, right: 0)
        thirdTab.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -5)
        
        viewControllers = [firstTab, secondTab, thirdTab]
        
    }

}
