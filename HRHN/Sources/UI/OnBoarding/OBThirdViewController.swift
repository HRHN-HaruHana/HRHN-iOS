//
//  OBThirdViewController.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/30.
//

import UIKit
import SnapKit

class OBThirdViewController: UIViewController {
    
    private let viewModel: OnBoardingViewModel
    private let picker = UIDatePicker()
    
    private lazy var titleLabel: UILabel = {
        $0.text = I18N.obNotiTitle
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var subTitleLabel: UILabel = {
        $0.text = I18N.obNotiTitle2
        $0.textColor = .dim
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var timeField: UITextField = {
        $0.text = "09:00 AM"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .point
        $0.backgroundColor = .cellFill
        $0.layer.cornerRadius = 10
        $0.textAlignment = .center
        $0.tintColor = .clear
        return $0
    }(UITextField())
    
    private lazy var disableLabel: UILabel = {
        $0.text = I18N.obNotiDeny
        $0.textColor = .dim
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(disableDidTap(tapGestureRecognizer:)))
        $0.addGestureRecognizer(tapGesture)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var descLabel: UILabel = {
        $0.text = I18N.obNotiDesc
        $0.textColor = .dim
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    init(with viewModel: OnBoardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        createTimePicker()
    }
}

extension OBThirdViewController {
    
    private func setUI() {
        view.addSubviews(titleLabel, subTitleLabel, timeField, disableLabel, descLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(80.constraintMultiplierTargetValue.horizontallyAdjusted)
            $0.height.equalTo(80)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        timeField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(120.constraintMultiplierTargetValue.horizontallyAdjusted)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(260)
            $0.height.equalTo(65)
        }
        
        disableLabel.snp.makeConstraints {
            $0.top.equalTo(timeField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
    }
    
    private func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDidTap))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    private func createTimePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: "09:00")!
        picker.date = date
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        timeField.inputView = picker
        timeField.inputAccessoryView = createToolBar()
    }
    
    @objc private func doneDidTap() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm aa "
        self.timeField.text = formatter.string(from: picker.date)
        self.view.endEditing(true)
        formatter.dateFormat = "HH:mm"
        viewModel.setNotiTime(with: formatter.string(from: picker.date))
    }
    
    @objc private func disableDidTap(tapGestureRecognizer: UITapGestureRecognizer) {
        viewModel.setNotiDisabled()
        timeField.text = "-- : --"
    }
    
}
