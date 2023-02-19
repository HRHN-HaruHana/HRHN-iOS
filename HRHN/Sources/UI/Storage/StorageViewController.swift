//
//  StorageViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//

import UIKit
import SnapKit

final class StorageViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: StorageViewModel

    
    // MARK: - LifeCycle
    
    init(viewModel: StorageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

// MARK: - Functions
extension StorageViewController {
    @objc func settingsDidTap(_ sender: UIButton) {
        let settingVC = SettingViewController(viewModel: SettingViewModel())
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}

// MARK: - Bindings
extension StorageViewController {
    
    private func bind() {

    }
}

// MARK: - UI Functions
extension StorageViewController {
    private func setUI(){
        view.backgroundColor = .background
    }
    
    private func setNavigationBar() {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsDidTap))
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
