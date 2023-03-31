//
//  UIBottomSheet.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/05.
//

import UIKit
import SwiftUI

final class UIBottomSheet: UIView {
    
    // MARK: Properties
    
    var bottomSheetHeight: CGFloat = 0 {
        didSet {
            bottomSheetView.snp.updateConstraints {
                $0.height.equalTo(bottomSheetHeight)
            }
        }
    }
    
    var bottomSheetPanGestureRecognizer = UIPanGestureRecognizer(target: nil, action: nil) {
        didSet {
            bottomSheetView.addGestureRecognizer(bottomSheetPanGestureRecognizer)
        }
    }

    var dimmedViewTapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil) {
        didSet {
            dimmedView.addGestureRecognizer(dimmedViewTapGestureRecognizer)
        }
    }
    
    var content = UIView() {
        didSet {
            setContents()
        }
    }
    
    // MARK: UI Properties
    
    private let dimmedView = UIDimmedView()
    private let grabber = UIGrabber()
    let bottomSheetView: UIView = {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        return $0
    }(UIView())
}

// MARK: UI Methods

extension UIBottomSheet {
    
    private func getUIWindow() -> UIWindow {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return UIWindow() }
        return window
    }
    
    func setLayout() {
        let window = getUIWindow()
        
        window.addSubviews(
            dimmedView,
            bottomSheetView
        )
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bottomSheetView.snp.makeConstraints {
            $0.height.equalTo(bottomSheetHeight)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(window.snp.bottom)
        }
        
        bottomSheetView.addSubviews(
            grabber
        )

        grabber.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(6)
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setContents() {
        bottomSheetView.addSubviews(
            content
        )

        content.snp.makeConstraints {
            $0.top.equalTo(grabber.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(bottomSheetView).inset(20)
        }
    }
    
    func presentBottomSheet() {
        let window = getUIWindow()
        
        window.rootViewController?.navigationController?.navigationBar.isUserInteractionEnabled = false
        window.rootViewController?.tabBarController?.tabBar.isUserInteractionEnabled = false
        
        bottomSheetView.layer.opacity = 1
        bottomSheetView.snp.remakeConstraints {
            $0.height.equalTo(bottomSheetHeight)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(window.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        UIView.animate(withDuration: 0.3) {
            window.layoutIfNeeded()
            self.dimmedView.layer.opacity = 0.3
            self.dimmedView.isUserInteractionEnabled = true
        }
    }
    
    func dismissBottomSheet() {
        let window = getUIWindow()

        window.rootViewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
        window.rootViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        
        bottomSheetView.snp.remakeConstraints {
            $0.height.equalTo(bottomSheetHeight)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(window.snp.bottom)
        }

        UIView.animate(withDuration: 0.3) {
            window.layoutIfNeeded()
            self.dimmedView.isUserInteractionEnabled = false
            self.dimmedView.layer.opacity = 0
        }
    }
    
    func removeContentsFromSuperView() {
        bottomSheetView.subviews.forEach({ $0.removeFromSuperview() })
    }
}

extension UIBottomSheet: Panable {
    func setPan() {
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGestureHandler)
        )
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func panGestureHandler(sender: UIPanGestureRecognizer) {
        setPanGesture(
            sender: sender
        ) { [weak self] in
            self?.dismissBottomSheet()
        }
    }
}
