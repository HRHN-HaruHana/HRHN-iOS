//
//  StorageViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//

import UIKit
import SnapKit

final class StorageViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: StorageViewModel

    private lazy var tableView: UITableView = { [weak self] in
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.register(StorageCell.self, forCellReuseIdentifier: "StorageCell")
        $0.register(StorageHeaderView.self, forHeaderFooterViewReuseIdentifier: "StorageHeaderView")
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    // MARK: - LifeCycle
    
    init(viewModel: StorageViewModel) {
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
extension StorageViewController {
    @objc func settingsDidTap(_ sender: UIButton) {
        let settingVC = SettingViewController(viewModel: SettingViewModel())
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}


// MARK: - UI Functions
extension StorageViewController {
    private func setUI(){
        view.backgroundColor = .background
        view.addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setNavigationBar() {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsDidTap))
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

// MARK: - UITableViewDataSource

extension StorageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.challenges.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorageCell", for: indexPath)
                as? StorageCell else { return UITableViewCell() }
        cell.configure(with: viewModel.challenges.value[indexPath.row])
        return cell
        
    }

}

// MARK: - UITableViewDelegate
extension StorageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109 + 20
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StorageHeaderView") as? StorageHeaderView else {
            return UIView()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reviewVC = ReviewViewController(viewModel: ReviewViewModel(
            from: .recordTab,
            challenge: viewModel.challenges.value[indexPath.row],
            navigationController: self.navigationController
        ))
        reviewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }

}


#if DEBUG
import SwiftUI

struct StorageViewController_Previews: PreviewProvider {
    static var previews: some View {
        StorageViewController(viewModel: StorageViewModel()).toPreview()
    }
}
#endif
