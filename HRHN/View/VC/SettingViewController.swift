//
//  SettingViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/28.
//

import UIKit
import SnapKit

enum SettingCellType: String {
    case defaultItem
    case alertToggle
    case alertTime
}

struct SettingItem {
    let text: String
    let secondaryText: String?
    let type: SettingCellType
    let imageName: String
}

struct SettingSection {
    let items: [SettingItem]
    let header: String?
    
    static func generateData() -> [SettingSection] {
        return [
            // NOTIFICATION
            SettingSection(items: [
                SettingItem(text: "알림", secondaryText: "하루 한 번, 알림을 드릴게요", type: .alertToggle, imageName: "bell.circle.fill"),
                SettingItem(text: "알림시간", secondaryText: nil, type: .alertTime, imageName: "clock.circle.fill")
            ], header: "NOTIFICATION"),
            // SUPPORT
            SettingSection(items: [
                SettingItem(text: "문의 및 지원", secondaryText: nil, type: .defaultItem, imageName: "phone.circle.fill"),
                SettingItem(text: "홈페이지", secondaryText: nil, type: .defaultItem, imageName: "globe"),
                SettingItem(text: "오픈소스 라이선스", secondaryText: nil, type: .defaultItem, imageName: "chevron.left.forwardslash.chevron.right")
            ], header: "SUPPORT")
        ]
    }
}



final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    let list = SettingSection.generateData()
    
    private lazy var tableView: UITableView = { [weak self] in
        $0.register(LinkTableViewCell.self,
                    forCellReuseIdentifier: LinkTableViewCell.identifier)
        $0.delegate = self
        $0.dataSource = self
//        $0.allowsSelection = false
        $0.alwaysBounceVertical = false
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
        self.navigationController?.popViewController(animated: true)
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
        let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonDidTap))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "설정"
    }
}


// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let target = list[indexPath.section].items[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LinkTableViewCell.identifier,
            for: indexPath
        ) as? LinkTableViewCell else { return UITableViewCell() }
        cell.configureCell(with: target)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return list[section].header
    }
    
}
