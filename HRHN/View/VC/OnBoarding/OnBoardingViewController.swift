//
//  OnBoardingViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/30.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    init(imageName: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
}

extension OnboardingViewController {
    
    func layout() {
        view.addSubviews(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
