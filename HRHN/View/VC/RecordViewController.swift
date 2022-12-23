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
    
    private let cellReuseID = "cell"
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let mockChallenges = [
        SampleChallenge(date: Date(), content: "긴거는 이렇게 어차피 글자 수 제한이 있기 때문에 짤릴 일은 없을 줄 알았는데", emoji: "emojiRed"),
        SampleChallenge(date: Date(), content: "그럼 잘렸을 때는 어떻게 처리해야되지? 그럼 잘렸을 때는 어떻게 처리해야되지?", emoji: "emojiYellow"),
        SampleChallenge(date: Date(), content: "짧은거", emoji: "emojiGreen")
    ]
    
    
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
extension RecordViewController {
    
    @objc func settingsDidTap(_ sender: UIButton) {
        // TODO: - GO TO SETTINGS
    }
    
}

// MARK: - UI Functions
extension RecordViewController {
    private func setUI(){
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
//        tableView.register(PlaceInfoHeaderView.self, forHeaderFooterViewReuseIdentifier: "PlaceInfoHeaderView")
//        tableView.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
//        tableView.register(EmptyReviewCell.self, forCellReuseIdentifier: "EmptyReviewCell")
        view.addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
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
        return mockChallenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyReviewCell", for: indexPath)
//                as? EmptyReviewCell else { return UITableViewCell() }
//        cell.selectionStyle = .none
//        return UITableViewCell()
        

        let item = mockChallenges[indexPath.row]
        
        let cell = UITableViewCell()
        cell.contentConfiguration = UIHostingConfiguration {
            HStack {
                VStack {
                    Text(":)")

                    Text("12/18")
                }
                Text("긴거는 이렇게 어차피 글자 수 제한이 있기 때문에 짤릴 일은 없을 줄 알았는데")
                    .font(.system(.subheadline, weight: .bold))
            }
        }
//        .background {
//            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                .fill(Color(uiColor: .secondarySystemGroupedBackground))
//        }
//        .margins(.horizontal, 16)

        return cell
        
    }
    
    
    
}

// MARK: - UITableViewDelegate
extension RecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = "지난 챌린지"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        headerView.addSubview(label)
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        
        return headerView
    }
    
}
