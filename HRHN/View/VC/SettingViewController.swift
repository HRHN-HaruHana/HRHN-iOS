//
//  SettingViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/28.
//

import UIKit
import SnapKit
import SafariServices

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
    let link: String?
}

struct SettingSection {
    let items: [SettingItem]
    let header: String?
    
    static func generateData() -> [SettingSection] {
        return [
            SettingSection(items: [
                SettingItem(text: "알림", secondaryText: "하루 한 번, 알림을 드릴게요", type: .alertToggle, imageName: "bell.fill", link: nil),
                SettingItem(text: "알림시간", secondaryText: nil, type: .alertTime, imageName: "clock.fill", link: nil)
            ], header: "NOTIFICATION"),
            SettingSection(items: [
                SettingItem(text: "문의 및 지원", secondaryText: nil, type: .defaultItem, imageName: "phone.fill", link: "https://hrhn.notion.site/d56ff2386c464543bbeb20284e3f3469"),
                SettingItem(text: "홈페이지", secondaryText: nil, type: .defaultItem, imageName: "globe", link: "https://hrhn.notion.site/f7ecd6dca58046b298ad8debfbcc762e"),
                SettingItem(text: "오픈소스 라이선스", secondaryText: nil, type: .defaultItem, imageName: "chevron.left.forwardslash.chevron.right", link: "https://hrhn.notion.site/2dd3252ad190433392c58f77e975cb18")
            ], header: "SUPPORT")
        ]
    }
}

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    let list = SettingSection.generateData()
    
    private lazy var titleView = UIView()
    private lazy var titleLabel: UILabel = {
        $0.text = "설정"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var tableView: UITableView = { [weak self] in
        $0.register(LinkTableViewCell.self, forCellReuseIdentifier: LinkTableViewCell.identifier)
        $0.delegate = self
        $0.dataSource = self
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
        let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonDidTap))
        navigationItem.leftBarButtonItem = leftBarButton
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let target = list[indexPath.section].items[indexPath.row]
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
        return list[section].header
    }
}
