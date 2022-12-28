//
//  SettingViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/28.
//

import UIKit
import SnapKit


final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = { [weak self] in
        $0.register(LinkTableViewCell.self,
                    forCellReuseIdentifier: LinkTableViewCell.identifier)
        $0.delegate = self
        $0.dataSource = self
//        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UITableView())
    
    // MARK: - LifeCycle
    
    init() {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}

// MARK: - Functions
extension SettingViewController {
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        // TODO: - GO TO SETTINGS
    }
    
}

// MARK: - UI Functions
extension SettingViewController {
    private func setUI(){
        view.backgroundColor = .background
        view.addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setNavigationBar() {
        let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(settingsDidTap))
        navigationItem.rightBarButtonItem = leftBarButton
    }
}


// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LinkTableViewCell.identifier,
            for: indexPath
        ) as? LinkTableViewCell ?? UITableViewCell()

        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {

    
}
