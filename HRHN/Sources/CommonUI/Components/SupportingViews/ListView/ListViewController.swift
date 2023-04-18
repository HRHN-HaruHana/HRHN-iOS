//
//  RecordViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/20.
//

import Combine
import SwiftUI
import UIKit
import SnapKit

final class ListViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: ListViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = { [weak self] in
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.register(ChallengeCell.self, forCellReuseIdentifier: "ChallengeCell")
        $0.register(ListHeaderView.self, forHeaderFooterViewReuseIdentifier: "ListHeaderView")
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    private lazy var bottomSheet: UIBottomSheet = {
        $0.bottomSheetHeight = 336
        $0.bottomSheetPanGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(bottomSheetViewDidPanned)
        )
        $0.dimmedViewTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(bottomSheetDimmedViewDidTapped)
        )
        return $0
    }(UIBottomSheet())
    
    private lazy var bottomSheetContent = ReviewView(viewModel: ReviewViewModel(from: self))
    
    // MARK: - LifeCycle
    
    init(with viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
        bottomSheet.setLayout()
        bottomSheet.content = bottomSheetContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPreviousChallenges()
        tableView.reloadData()
    }
}

// MARK: - Functions
extension ListViewController {
    
    @objc func settingsDidTap(_ sender: UIButton) {
        let settingVC = SettingViewController(viewModel: SettingViewModel())
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}

// MARK: - UI Functions
extension ListViewController {
    private func setUI(){
        view.addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - CustomNavBar

extension ListViewController: CustomNavBar {
    private func setNavigationBar() {
        setNavigationBarAppLogo()
        setNavigationBarBackButton()
        setNavigationBarRightIconButton(systemName: "gearshape.fill", action: #selector(settingsDidTap))
    }
}


// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChallengeCell",
            for: indexPath
        ) as? ChallengeCell else { return UITableViewCell() }
        cell.configure(with: viewModel.challenges[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109 + 20
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ListHeaderView") as? ListHeaderView else {
            return UIView()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bottomSheetContent.viewModel?.challenge = viewModel.challenges[indexPath.row]
        bottomSheetContent.viewModel?.selectedEmoji = viewModel.challenges[indexPath.row].emoji
        bottomSheet.presentBottomSheet()
    }

}

// MARK: - Bottom Sheet Gesture Selectors

extension ListViewController {
    @objc func bottomSheetDimmedViewDidTapped() {
        bottomSheet.dismissBottomSheet()
        viewModel.fetchPreviousChallenges()
        tableView.reloadData()
    }
    
    @objc func bottomSheetViewDidPanned(sender: UIPanGestureRecognizer) {
        bottomSheet.panGestureHandler(sender: sender)
    }
}
