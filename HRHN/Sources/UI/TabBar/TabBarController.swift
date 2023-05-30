//
//  TabBarController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/20.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let dimmedView = UIDimmedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setTabBar()
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
        
        dimmedView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    
    private func setLayout() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setTabBar() {
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
        
        viewControllers = [firstTab, secondTab]
    }

    func dim() {
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.layer.opacity = 0.2
        }
    }
    
    func brighten() {
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.layer.opacity = 0
        }
    }
}
