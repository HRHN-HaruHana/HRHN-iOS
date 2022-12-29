//
//  OnBoardingViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/30.
//

import SwiftUI
import UIKit
import SnapKit

class OnBoardingPageViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    let initialPage = 0
    private var currentIdx = 0
    
    private lazy var backButton: UIButton = {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .primaryActionTriggered)
        $0.layer.isHidden = true
        return $0
    }(UIButton())
    
    private lazy var nextButton: UIFullWidthButton = {
        $0.title = "시작하기"
        $0.action = UIAction { _ in
            self.nextButtonDidTap()
        }
        return $0
    }(UIFullWidthButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
}

extension OnBoardingPageViewController {
    
    private func setUI() {
        dataSource = self
        delegate = self
        
        view.backgroundColor = .background
        
        let page1 = OnboardingViewController(imageName: "onboarding-1")
        let page2 = OnboardingViewController(imageName: "blue")
        let page3 = OnboardingViewController(imageName: "green")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        removeSwipeGesture()
    }
    
    private func setLayout() {
        view.addSubviews(backButton, nextButton)
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}


// MARK: - DataSources

extension OnBoardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
    
}

// MARK: - Delegates

extension OnBoardingPageViewController: UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        currentIdx = currentIndex
        updateButtonIfNeeded()
    }
    
    
}

// MARK: - Actions

extension OnBoardingPageViewController {
    
    @objc private func backButtonDidTap(_ sender: UIButton) {
        if currentIdx != 0 {
            currentIdx -= 1
            print("뒤로가기\(currentIdx)")
            goToPreviousPage()
            updateButtonIfNeeded()
        }
    }
    
    private func nextButtonDidTap() {
        if currentIdx == pages.count - 1{
            let controller = TabBarController()
            controller.modalPresentationStyle = .fullScreen
            //      UserDefaults.standard.hasOnboarded = true
            self.view.window?.rootViewController = controller
            self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
            
        } else {
            currentIdx += 1
            goToNextPage()
            updateButtonIfNeeded()
        }
    }
    
    private func updateButtonIfNeeded() {
        switch currentIdx {
        case 0:
            nextButton.title = "시작하기"
            backButton.layer.isHidden = true
        case 1:
            nextButton.title = "다음"
            backButton.layer.isHidden = false
        case 2:
            nextButton.title = "완료"
            backButton.layer.isHidden = false
        default:
            return
        }
    }
    
    private func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    private func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .reverse, animated: animated, completion: completion)
    }
    
    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
}
