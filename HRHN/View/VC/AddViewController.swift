//
//  AddViewController.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/28.
//

import UIKit

final class AddViewController: UIViewController {
    
    // MARK: Properties
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setUI()
        setNavigationBar()
    }
}

// MARK: Bindings

private extension AddViewController {
    
    func bind() {
        
    }
}

// MARK: UI Functions

private extension AddViewController {
    
    func setUI() {
        
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
    }
}
