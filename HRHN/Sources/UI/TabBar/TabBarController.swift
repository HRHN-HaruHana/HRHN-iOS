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
        firstTab.tabBarItem = UITabBarItem(title: I18N.tabToday, image: UIImage(systemName: "sparkles"), selectedImage: UIImage(systemName: "sparkles"))
        
        let recordVC = RecordViewController(with: RecordViewModel())
        let secondTab = UINavigationController(rootViewController: recordVC)
        secondTab.tabBarItem = UITabBarItem(title: I18N.tabRecord, image: UIImage(systemName: "list.bullet.circle"), selectedImage: UIImage(systemName: "list.bullet.circle.fill"))
        
        let storageVC = StorageViewController(viewModel: StorageViewModel())
        let thirdTab = UINavigationController(rootViewController: storageVC)
        thirdTab.tabBarItem = UITabBarItem(title: I18N.tabStorage, image: UIImage(systemName: "archivebox"), selectedImage: UIImage(systemName: "archivebox.fill"))
        
        viewControllers = [firstTab, secondTab, thirdTab]
        
    }

}
