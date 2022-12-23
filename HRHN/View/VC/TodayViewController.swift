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
        /*
        let coreDataManger = CoreDataManager.shared
        coreDataManger.insertChallenge(Challenge(id: UUID(),
                                          date: tomorrow,
                                          content: "안녕하세요",
                                          emoji: Emoji.blue))

        // 코어데이터 싱글톤 매니저
        let coreDataManger = CoreDataManager.shared
        
        // 챌린지 등록
        coreDataManger.insertChallenge(Challenge(id: UUID(),
                                          date: Date(),
                                          content: "안녕하세요",
                                          emoji: Emoji.blue))
        
        // 챌린지 전체 가져오기 (최신순)
        coreDataManger.getChallenges()
        
        // 특정날짜 챌린지만 가져오기
        // let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        coreDataManger.getChallengeOf(Date())
        
        // 가장최근 챌린지 가져오기
        coreDataManger.getChallenges()[0]
        
        // 챌린지 업데이트
        coreDataManger.updateChallenge(Challenge(id: UUID(),
                                          date: Date(),
                                          content: "안녕히계세요",
                                          emoji: Emoji.green))
        
        // 특정날짜의 챌린지 삭제
        coreDataManger.deleteChallenge(Date())
        
        // 전체 챌린지 삭제
        coreDataManger.deleteAllChallenges()
        */
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
