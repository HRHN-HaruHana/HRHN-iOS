//
//  BottomSheet.swift
//  HRHN
//
//  Created by 민채호 on 2023/05/09.
//

import UIKit

final class BottomSheetController: UIViewController {
    
    // MARK: Properties
    
    private let content: UIView
    var sheetWillDismiss: (() -> Void)?
    var emojiDidTap: (() -> Void)?
    
    // MARK: UI Properties
    
    private let grabber = UIGrabber()
    
    private lazy var backgroundView: UIView = {
        $0.backgroundColor = .clear
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissBottomSheet)
        )
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UIView())
    
    private lazy var bottomSheetCellView: UIView = {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGestureHandler)
        )
        $0.addGestureRecognizer(panGestureRecognizer)
        return $0
    }(UIView())
    
    private let bottomSheetStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    init(content: UIView) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomSheetController {
    
    private func setLayout() {
        
        view.addSubviews(
            backgroundView,
            bottomSheetCellView
        )
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bottomSheetCellView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        bottomSheetCellView.addSubview(
            bottomSheetStackView
        )
        
        bottomSheetStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.bottom.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bottomSheetStackView.addArrangedSubviews(
            grabber,
            content
        )
        
        grabber.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(6)
        }
    }
}

extension BottomSheetController {
    
    @objc func dismissBottomSheet() {
        bottomSheetCellView.layer.opacity = 1
        sheetWillDismiss?()
    }
    
    func emojiTap() {
        emojiDidTap?()
    }
}

extension BottomSheetController: Panable {
    
    @objc private func panGestureHandler(sender: UIPanGestureRecognizer) {
        setPanGesture(
            sender: sender
        ) { [weak self] in
            self?.dismissBottomSheet()
        }
    }
}
