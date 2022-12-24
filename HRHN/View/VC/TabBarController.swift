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
        tabBar.tintColor = UIColor.point
    }
    
    private func setUpTabBar() {
        let todayVC = TodayViewController(viewModel: TodayViewModel())
        let firstTab = UINavigationController(rootViewController: todayVC)
        firstTab.tabBarItem = UITabBarItem(title: "오늘의 챌린지", image: UIImage(systemName: "sparkles"), selectedImage: UIImage(systemName: "sparkles"))
        
        let recordVC = RecordViewController()
        let secondTab = UINavigationController(rootViewController: recordVC)
        secondTab.tabBarItem = UITabBarItem(title: "지난 챌린지", image: UIImage(systemName: "list.bullet.circle"), selectedImage: UIImage(systemName: "list.bullet.circle.fill"))
        
        viewControllers = [firstTab, secondTab]
        
    }

}
