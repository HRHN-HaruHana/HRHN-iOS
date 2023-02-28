//
//  ReviewViewController.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/26.
//

import Combine
import SwiftUI
import UIKit
import SnapKit

final class ReviewViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: ReviewViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var reviewViewHC = UIHostingController(rootView: ReviewView(viewModel: viewModel))
    
    private let cell: UIView = {
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        $0.backgroundColor = .background
        return $0
    }(UIView())
    
    private lazy var backgroundView: UIView = {
//        $0.backgroundColor = .red
        $0.layer.zPosition = -1
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundViewTapped)
        )
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(UIView())
    
    // MARK: LifeCycle
    
    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setUI()
        setNavigationBar()
    }
}

// MARK: Bindings

extension ReviewViewController {
    
    private func bind() {

    }
}

// MARK: UI Functions

extension ReviewViewController {
    
    private func setUI() {
//        view.backgroundColor = .background
//        view.layer.cornerRadius = 24
//        view.clipsToBounds = true
//        view.snp.makeConstraints {
//            $0.height.equalTo(346)
//            $0.width.equalTo(UIScreen.main.bounds.width - 40)
//        }
        view.addSubviews(
            cell,
            backgroundView
        )
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cell.snp.makeConstraints {
            $0.height.equalTo(346)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        addChild(reviewViewHC)
//        view.addSubview(reviewViewHC.view)
        cell.addSubview(reviewViewHC.view)
        reviewViewHC.didMove(toParent: self)
        reviewViewHC.view.snp.makeConstraints {
            $0.edges.equalTo(cell).inset(20)
        }
        
    }
}

// MARK: Methods

extension ReviewViewController {
    @objc private func backgroundViewTapped() {
        dismiss(animated: true)
    }
}

extension ReviewViewController: CustomNavBar {
    private func setNavigationBar() {
        setNavigationBarBackButton()
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
//        button.action = UIAction { _ in
//            self.navigationController?.pushViewController(
//                ReviewViewController(viewModel: ReviewViewModel(
//                    from: .addTab,
//                    challenge: Challenge(
//                        id: UUID(),
//                        date: Date(),
//                        content: "Preview",
//                        emoji: .none
//                    ),
//                    navigationController: self.navigationController
//                )),
//                animated: true
//            )
//        }
    }
    
    func setLayout() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

struct ReviewViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: ReviewViewNavigationPreview())
            .toPreview()
            .ignoresSafeArea()
    }
}
#endif
