//
//  ReviewViewController.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/26.
//

import UIKit

final class ReviewViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
    }
}
