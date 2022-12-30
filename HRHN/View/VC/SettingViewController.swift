//
//  SettingViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/28.
//

import UIKit
import SnapKit
import SafariServices

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: SettingViewModel
    
    private lazy var titleView = UIView()
    private lazy var titleLabel: UILabel = {
        $0.text = "설정"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var tableView: UITableView = { [weak self] in
        $0.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        $0.delegate = self
        $0.dataSource = self
        $0.alwaysBounceVertical = false
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UITableView())
    
    // MARK: - LifeCycle
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUI()
        setNavigationBar()
    }
    
}

// MARK: - Functions
extension SettingViewController {
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UI Functions
extension SettingViewController {
    private func setUI(){
        view.backgroundColor = .background
        view.addSubviews(titleView, tableView)
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(66)
        }
        titleView.addSubviews(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
    }
}


// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.list.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.value[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let target = viewModel.list.value[indexPath.section].items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingCell.identifier,
            for: indexPath
        ) as? SettingCell else { return UITableViewCell() }
        cell.configureCell(with: target)
        cell.setAlertHandler = {
            self.viewModel.setNotAllowed(with: $0)
        }
        cell.setTimeHandler = {
            self.viewModel.setNotiTime(with: $0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let target = viewModel.list.value[indexPath.section].items[indexPath.row]
        if let url = URL(string: target.link ?? "") {
          let safariView: SFSafariViewController = SFSafariViewController(url: url)
          self.present(safariView, animated: true, completion: nil)
        }
    }
    
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.list.value[section].header
    }
}
