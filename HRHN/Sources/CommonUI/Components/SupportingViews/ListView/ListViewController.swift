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
    
    private lazy var bottomSheet: BottomSheetController = {
        $0.sheetWillDismiss = { [weak self] in
            self?.dismissBottomSheet()
        }
        return $0
    }(BottomSheetController(content: bottomSheetContentView))

    private let bottomSheetContentView = ReviewView(viewModel: ReviewViewModel(from: .list))
    
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
        viewModel.fetchPreviousChallenges()
        tableView.reloadData()
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
    
    private func bind() {
        
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
        bottomSheetContentView.viewModel?.challenge = viewModel.challenges[indexPath.row]
        bottomSheetContentView.viewModel?.selectedEmoji = viewModel.challenges[indexPath.row].emoji
        presentBottomSheet()
    }

}
