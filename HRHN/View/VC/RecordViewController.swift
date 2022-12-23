//
//  RecordViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/20.
//

import SwiftUI
import UIKit
import SnapKit

struct SampleChallenge {
    let date: Date
    let content: String
    let emoji: String
}


final class RecordViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: RecordViewModel
    
    private lazy var tableView: UITableView = { [weak self] in
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.register(ChallengeCell.self, forCellReuseIdentifier: "ChallengeCell")
        $0.register(RecordHeaderView.self, forHeaderFooterViewReuseIdentifier: "RecordHeaderView")
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    
    
    // MARK: - LifeCycle
    
    init(with viewModel: RecordViewModel) {
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
extension RecordViewController {
    
    @objc func settingsDidTap(_ sender: UIButton) {
        // TODO: - GO TO SETTINGS
    }
    
}

// MARK: - UI Functions
extension RecordViewController {
    private func setUI(){
        view.backgroundColor = .systemBackground
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

extension RecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath)
                as? ChallengeCell else { return UITableViewCell() }
        cell.configure(with: viewModel.challenges[indexPath.row])
        return cell
        
    }
    
    
    
}

// MARK: - UITableViewDelegate
extension RecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109 + 20
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RecordHeaderView") as? RecordHeaderView else {
            return UIView()
        }
        return headerView
    }

}
