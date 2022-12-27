//
//  ReviewViewController.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/26.
//

import Combine
import UIKit
import SnapKit

final class ReviewViewController: UIViewController {
    
    // MARK: UI
    
    private lazy var nextButton: UIFullWidthButton = {
        $0.title = "다음"
        $0.action = UIAction { _ in
            self.viewModel.updateChallenge()
//            self.navigationController?.pushViewController()
        }
        $0.isEnabled = false
        return $0
    }(UIFullWidthButton())
    
    private lazy var reviewViewHC = UIHostingController(rootView: ReviewView(with: viewModel))
    
    // MARK: Property
    
    private let viewModel: ReviewViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    
    init(with viewModel: ReviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setNavigationBar()
        setUI()
        setLayout()
    }
    
    // MARK: Methods
    
    private func bind() {
        viewModel.$selectedEmoji
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if $0 == .none {
                    self?.nextButton.isEnabled = false
                } else {
                    self?.nextButton.isEnabled = true
                }
            }
            .store(in: &cancelBag)
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setUI() {
        view.backgroundColor = .background
        
        addChild(reviewViewHC)
        view.addSubview(reviewViewHC.view)
        reviewViewHC.didMove(toParent: self)
    }
    
    private func setLayout() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        reviewViewHC.view.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
}

// MARK: - Preview

#if DEBUG
final class ReviewViewNavigationPreview: UIViewController {
    private let button: UIFullWidthButton = {
        $0.title = "내비게이션바 확인"
        return $0
    }(UIFullWidthButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setLayout()
    }
    
    func setButton() {
        button.action = UIAction { _ in
            self.navigationController?.pushViewController(ReviewViewController(with: ReviewViewModel()), animated: true)
        }
    }
    
    func setLayout() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

import SwiftUI

struct ReviewViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: ReviewViewNavigationPreview())
            .toPreview()
            .ignoresSafeArea()
    }
}
#endif
