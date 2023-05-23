//
//  UICalendarPageViewController.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/31.
//

import Combine
import UIKit
import SwiftUI

final class CalendarPageViewController: UIPageViewController {
    
    private let viewModel: CalendarPageViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private var isToastMessagePresented = false
    private var selectedChallenge: Challenge?
    
    private lazy var bottomSheet: BottomSheetController = {
        $0.sheetWillDismiss = { [weak self] in
            self?.dismissBottomSheet()
        }
        $0.deleteButtonDidTap = { [weak self] in
            self?.presentToastMessage()
        }
        return $0
    }(BottomSheetController(content: bottomSheetContentView))

    private let bottomSheetContentView = ReviewView(viewModel: ReviewViewModel(from: .calendar))
    
    private lazy var toastMessage: ToastMessage = {
        let action = UIAction { _ in
            self.undoDeletionAndDismissToastMessage()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(ToastMessage(
        isButton: true,
        title: "챌린지가 삭제됐어요",
        subtitle: "되돌리기",
        subtitleSymbol: UIImage(systemName: "arrow.uturn.backward")
    ))
    
    init(viewModel: CalendarPageViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
}

extension CalendarPageViewController {
    
    private func setUI() {
        let hc = UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(
            calendarDate: Date()
        )))
        setViewControllers([hc], direction: .forward, animated: false)
        dataSource = self
        delegate = self
        
        setToastMessageLayout()
    }
    
    private func bind() {
        cancelBag.removeAll()
        if let hc = viewControllers?.first as? UIHostingController<CalendarView> {
            hc.rootView.willPresentBottomSheet
                .sink { [weak self] in
                    self?.presentBottomSheet()
                }
                .store(in: &cancelBag)
            hc.rootView.fetchBottomSheetContent
                .sink { [weak self] challenge in
                    self?.bottomSheetContentView.viewModel.challenge = challenge
                    self?.bottomSheetContentView.viewModel.selectedEmoji = challenge?.emoji
                    self?.selectedChallenge = challenge
                }
                .store(in: &cancelBag)
            hc.rootView.goToCurrentMonth
                .sink{ [weak self] in
                    self?.goToCurrentMonth()
                }
                .store(in: &cancelBag)
        }
    }
}

extension CalendarPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentPageDate = hc.rootView.viewModel.calendarDate
        let lastMonth = viewModel.addMonths(-1, to: currentPageDate)
        return UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(calendarDate: lastMonth)))
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let hc = viewController as? UIHostingController<CalendarView> else { return nil }
        let currentViewDate = hc.rootView.viewModel.calendarDate
        if currentViewDate.isCurrentMonth() {
            return nil
        } else {
            let nextMonth = viewModel.addMonths(1, to: currentViewDate)
            return UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(calendarDate: nextMonth)))
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        bind()
    }
}

extension CalendarPageViewController {
    
    private func goToCurrentMonth() {
        let hc = UIHostingController(rootView: CalendarView(viewModel: CalendarViewModel(calendarDate: Date())))
        setViewControllers([hc], direction: .forward, animated: true)
        bind()
    }
}

// MARK: BottomSheet Methods

extension CalendarPageViewController {
    
    private func presentBottomSheet() {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.dim()
        bottomSheet.modalPresentationStyle = .overFullScreen
        bottomSheet.modalTransitionStyle = .coverVertical
        present(bottomSheet, animated: true)
    }
    
    private func dismissBottomSheet() {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.brighten()
        dismiss(animated: true)
        guard let hc = self.viewControllers?.first as? UIHostingController<CalendarView> else { return }
        hc.rootView.viewModel.fetchSelectedChallenge()
    }
}

// MARK: ToastMessage Methods

extension CalendarPageViewController {
    
    private func undoDeletionAndDismissToastMessage() {
        guard let selectedChallenge = self.selectedChallenge else { return }
        CoreDataManager.shared.insertChallenge(selectedChallenge)
        guard let hc = viewControllers?.first as? UIHostingController<CalendarView> else { return }
        hc.rootView.viewModel.fetchSelectedChallenge()
        dismissToastMessage()
    }
    
    private func setToastMessageLayout() {
        guard let navigationControllerView = navigationController?.view else { return }
        navigationControllerView.addSubview(toastMessage)
        
        toastMessage.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(navigationControllerView.snp.top)
        }
    }
    
    private func presentToastMessage() {
        guard let navigationControllerView = navigationController?.view else { return }
        
        if !isToastMessagePresented {
            isToastMessagePresented = true
            UIView.animate(withDuration: 0.3) {
                self.toastMessage.snp.remakeConstraints {
                    $0.height.equalTo(55)
                    $0.centerX.equalToSuperview()
                    $0.top.equalTo(navigationControllerView.safeAreaLayoutGuide.snp.top).offset(10)
                }
                navigationControllerView.layoutIfNeeded()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismissToastMessage()
            }
        }
    }
    
    private func dismissToastMessage() {
        guard let navigationControllerView = navigationController?.view else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.toastMessage.snp.remakeConstraints {
                $0.height.equalTo(55)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(navigationControllerView.snp.top)
            }
            navigationControllerView.layoutIfNeeded()
        } completion: { _ in
            self.isToastMessagePresented = false
        }
    }
}
