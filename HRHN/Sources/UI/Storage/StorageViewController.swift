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
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .point
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.configuration = config
        button.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
        return button
    }()
    
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
        viewModel.fetchStoredItems()
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
    
    @objc func floatingButtonDidTap(_ sender: UIButton) {
        self.viewModel.addStorageItem()
        tableView.reloadData()
    }
}


// MARK: - UI Functions
extension StorageViewController {
    private func setUI(){
        view.backgroundColor = .background
        view.addSubviews(tableView, floatingButton)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.width.height.equalTo(55)
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
        viewModel.storedItem.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorageCell", for: indexPath)
                as? StorageCell else { return UITableViewCell() }
        cell.configure(with: viewModel.storedItem.value[indexPath.row])
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
        self.viewModel.deleteStorageItem(item: viewModel.storedItem.value[indexPath.row])
        tableView.reloadData()
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
