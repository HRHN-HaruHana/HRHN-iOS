//
//  TabBarController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/20.
//

import UIKit

class TabBarController: UITabBarController {
    
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
        
        let recordVC = RecordViewController()
        let secondTab = UINavigationController(rootViewController: recordVC)
        secondTab.tabBarItem = UITabBarItem(
            title: I18N.tabRecord,
            image: UIImage(named: Assets.TabbarIcons.recordUnselected.rawValue),
            selectedImage: UIImage(named: Assets.TabbarIcons.recordSelected.rawValue)
        )
        
        let storageVC = UIViewController() // TODO: Change to StorageViewController
        let thirdTab = UINavigationController(rootViewController: storageVC)
        thirdTab.tabBarItem = UITabBarItem(
            title: I18N.tabStorage,
            image: UIImage(named: Assets.TabbarIcons.storageUnselected.rawValue),
            selectedImage: UIImage(named: Assets.TabbarIcons.storageSelected.rawValue)
        )
        
        viewControllers = [firstTab, secondTab, thirdTab]
        
    }

}
