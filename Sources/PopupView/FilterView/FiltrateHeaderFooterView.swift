//
//  FilterHeaderView.swift
//  PopupView_Example
//
//  Created by Duanhu on 2025/6/7.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class FiltrateHeaderView: UICollectionReusableView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to item: FiltrateHeaderItemViewModel) {
        titleLabel.update(with: item.config)
    }
}

class FiltrateLineFooterView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.bottomAnchor.constraint(equalTo: bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FiltrateDateFooterView: FiltrateLineFooterView {
    
    private var item: FiltrateHeaderItemViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let titles = ["开始时间：", "结束时间："]
        
        let subViews = titles.map { title in
            let lable = UILabel()
            lable.text = title
            
            let button = UnfoldButton(showRightLine: false)
            button.titleLabel.text = "2025-06-11"
            button.titleLabel.textColor = .black
            button.titleLabel.font = .systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
            button.backgroundColor = UIColor(red: 1, green: 0.56, blue: 0.36, alpha: 0.1)
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 140.0 * frame.width / 324.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 32.0 * frame.width / 324.0).isActive = true
            
            let stackView = UIStackView(arrangedSubviews: [lable, button])
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.spacing = 6
            return stackView
        }
        
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showDatePicker(_ sender: UIButton) {
//        var current: Date
//        if sender.tag == 10086 {
//            current = item?.startTime ?? Date()
//        } else {
//            current = item?.endTime ?? Date()
//        }
        DatePickerView()
            .title("选择时间")
            .datePickerMode(.date)
            .completion({ item in
                debugPrint("选择： \(item)")
            })
            .actionSheet()
    }
}
