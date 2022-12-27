//
//  ReviewViewController.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/26.
//

import UIKit
import SnapKit

final class ReviewViewController: UIViewController {
    
    private let viewModel: ReviewViewModel
    private lazy var reviewViewHC = UIHostingController(rootView: ReviewView(with: viewModel))
    
    init(with viewModel: ReviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
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
        reviewViewHC.view.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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
