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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateTabBarIcons()
        }
    }
    
    private func setUI() {
        view.backgroundColor = .background
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundEffect = UIBlurEffect(style: .prominent)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
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
    
    private func updateTabBarIcons() {
        guard let items = tabBar.items else { return }
        
        for (index, item) in items.enumerated() {
            switch index {
            case 0:
                item.image = UIImage(named: Assets.TabbarIcons.todayUnselected.rawValue)
                item.selectedImage = UIImage(named: Assets.TabbarIcons.todaySelected.rawValue)
            case 1:
                item.image = UIImage(named: Assets.TabbarIcons.recordUnselected.rawValue)
                item.selectedImage = UIImage(named: Assets.TabbarIcons.recordSelected.rawValue)
            default:
                item.image = UIImage()
                item.selectedImage = UIImage()
            }
        }
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
