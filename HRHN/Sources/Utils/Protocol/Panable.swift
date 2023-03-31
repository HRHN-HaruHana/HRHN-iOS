//
//  Panable.swift
//  HRHN
//
//  Created by 민채호 on 2023/03/05.
//

import UIKit

protocol Panable {
    func setPanGesture(
        sender: UIPanGestureRecognizer,
        dismissAction: @escaping () -> Void
    )
}

extension Panable where Self: UIView {
    func setPanGesture(
        sender: UIPanGestureRecognizer,
        dismissAction: @escaping () -> Void
    ) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        
        let translation = sender.translation(in: window.rootViewController?.view)
        let translationLimit: CGFloat = 30
        let translationXFactor: CGFloat = 1.005
        let translationYFactor: CGFloat = 1.005
        
        let velocity = sender.velocity(in: window.rootViewController?.view)
        
        guard let pannedView = sender.view else { return }
        
        var translationX: CGFloat {
            if translation.x > 0 {
                return translationLimit * (1-1/pow(translationXFactor, translation.x))
            } else {
                return -translationLimit * (1-1/pow(translationXFactor, translation.x.magnitude))
            }
        }
        
        var translationY: CGFloat {
            if translation.y > 0 {
                return translation.y
            } else {
                return -translationLimit * (1-1/pow(translationYFactor, translation.y.magnitude))
            }
        }
        
        pannedView.transform = CGAffineTransform(
            translationX: translationX,
            y: translationY
        )
        
        switch sender.state {
        case .changed:
            if translation.y > 0 {
                pannedView.layer.opacity = 1 - Float(1-1/pow(translationYFactor, translation.y))
            }
        case .ended:
            let translationThreshold: CGFloat = 100
            let velocityThreshold: CGFloat = 300
            
            if translation.y > translationThreshold || velocity.y > velocityThreshold {
                dismiss()
            } else {
                rollback()
            }
        default:
            break
        }
        
        func dismiss() {
            UIView.animate(withDuration: 0.3) {
                dismissAction()
                pannedView.transform = .identity
            }
        }
        
        func rollback() {
            UIView.animate(withDuration: 0.3) {
                pannedView.transform = .identity
                pannedView.layer.opacity = 1
            }
        }
    }
}
