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
    private let reserveChallengeMethodHandler = ReserveChallengeViewHandler()
    private var cancelBag = Set<AnyCancellable>()
    
    private var isToastMessagePresented = false
    private var selectedChallenge: Challenge?
    private var toastMessageTimer: Timer?
    
    private lazy var reviewSheet: BottomSheetController = {
        $0.sheetWillDismiss = { [weak self] in
            self?.dismissSheet()
        }
        $0.deleteButtonDidTap = { [weak self] in
            self?.presentToastMessage()
        }
        return $0
    }(BottomSheetController(content: reviewSheetContentView))
    private let reviewSheetContentView = ReviewView(viewModel: ReviewViewModel(from: .calendar))
    
    private lazy var reserveSheet: BottomSheetController = {
        $0.sheetWillDismiss = { [weak self] in
            self?.dismissSheet()
            self?.reserveChallengeMethodHandler.sheetDidDismissSubject.send()
        }
        return $0
    }(BottomSheetController(content: reserveSheetContentView))
    private lazy var reserveSheetContentView = ReserveChallengeView(
        viewModel: ReserveChallengeViewModel(),
        methodHandler: reserveChallengeMethodHandler
    )
    
    private lazy var toastMessage: ToastMessage = {
        let undoAction = UIAction { _ in
            self.undoDeletion()
            self.dismissToastMessage()
        }
        $0.addAction(undoAction, for: .touchUpInside)
        
        $0.pauseTimer = { [weak self] in
            self?.toastMessageTimer?.invalidate()
        }
        $0.startTimer = { [weak self] in
            self?.dismissToastMessageAfter(seconds: 1)
        }
        $0.dismissImmediately = { [weak self] in
            self?.dismissToastMessage()
        }
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
            hc.rootView.willPresentReviewSheet
                .sink { [weak self] in
                    self?.presentSheet(sheet: self?.reviewSheet)
                }
                .store(in: &cancelBag)
            hc.rootView.willPresentReserveSheet
                .sink { [weak self] in
                    self?.presentSheet(sheet: self?.reserveSheet)
                    self?.reserveChallengeMethodHandler.sheetWillPresentSubject.send()
                }
                .store(in: &cancelBag)
            hc.rootView.fetchReviewSheetContent
                .sink { [weak self] challenge in
                    self?.selectedChallenge = challenge
                    self?.reviewSheetContentView.viewModel.challenge = challenge
                    self?.reviewSheetContentView.viewModel.selectedEmoji = challenge?.emoji
                }
                .store(in: &cancelBag)
            hc.rootView.fetchReserveSheetContent
                .sink { [weak self] selectedDate, selectedChallenge in
                    self?.selectedChallenge = selectedChallenge
                    self?.reserveSheetContentView.viewModel.selectedDate = selectedDate
                    self?.reserveSheetContentView.viewModel.selectedChallenge = selectedChallenge                    
                }
                .store(in: &cancelBag)
            hc.rootView.goToCurrentMonth
                .sink{ [weak self] in
                    self?.goToCurrentMonth()
                }
                .store(in: &cancelBag)
        }
        reserveChallengeMethodHandler.sheetDidDismissSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.dismissSheet()
            }
            .store(in: &cancelBag)
        reserveChallengeMethodHandler.deleteButtonDidTapSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.presentToastMessage()
            }
            .store(in: &cancelBag)
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
    
    private func presentSheet(sheet: BottomSheetController?) {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.dim()
        
        guard let sheet else { return }
        sheet.modalPresentationStyle = .overFullScreen
        sheet.modalTransitionStyle = .coverVertical
        present(sheet, animated: true)
    }
    
    private func dismissSheet() {
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.brighten()
        
        dismiss(animated: true)
        
        guard let hc = self.viewControllers?.first as? UIHostingController<CalendarView> else { return }
        hc.rootView.viewModel.fetchSelectedChallenge()
    }
}

// MARK: ToastMessage Methods

extension CalendarPageViewController {
    
    private func undoDeletion() {
        guard let selectedChallenge = self.selectedChallenge else { return }
        CoreDataManager.shared.insertChallenge(selectedChallenge)
        guard let hc = viewControllers?.first as? UIHostingController<CalendarView> else { return }
        hc.rootView.viewModel.fetchSelectedChallenge()
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
            toastMessageTimer?.invalidate()
            
            UIView.animate(withDuration: 0.3) {
                self.toastMessage.snp.remakeConstraints {
                    $0.height.equalTo(55)
                    $0.centerX.equalToSuperview()
                    $0.top.equalTo(navigationControllerView.safeAreaLayoutGuide.snp.top).offset(10)
                }
                navigationControllerView.layoutIfNeeded()
            }
            
            dismissToastMessageAfter(seconds: 2)
        }
    }
    
    private func dismissToastMessageAfter(seconds: Double) {
        toastMessageTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { _ in
            self.dismissToastMessage()
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
