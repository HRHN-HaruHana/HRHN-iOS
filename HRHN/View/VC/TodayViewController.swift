//
//  TodayViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//

import UIKit
import SnapKit

final class TodayViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var testButton: UIButton = {
        $0.configuration = .filled()
        $0.setTitle("코어데이터테스트", for: .normal)
        $0.addTarget(self, action: #selector(testDidTap(_:)), for: .primaryActionTriggered)
        return $0
    }(UIButton())
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
}

// MARK: - Functions
extension TodayViewController {
    
    @objc func testDidTap(_ sender: UIButton) {
        // TODO: - Delete
    }
    
}

// MARK: - UI Functions
extension TodayViewController {
    private func setUI(){
        view.backgroundColor = .systemBackground
        view.addSubviews(testButton)
        testButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
