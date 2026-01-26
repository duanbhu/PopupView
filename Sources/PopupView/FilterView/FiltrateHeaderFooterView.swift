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
    
    public var item: FiltrateHeaderItemViewModel? {
        didSet {
            self.updateUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let titles = ["开始时间：", "结束时间："]
        
        let subViews = titles.enumerated().map { idx, title in
            let lable = UILabel()
            lable.text = title
            
            let button = UnfoldButton(showRightLine: false)
            button.titleLabel.text = "2026-06-11"
            button.titleLabel.textColor = .black
            button.titleLabel.font = .systemFont(ofSize: 14)
            button.tag = 10086 + idx
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
    
    // 弹出选择时间窗口
    // 弹出选择时间窗口
    @objc func showDatePicker(_ sender: UIButton) {
        var current: Date
        var minimumDate: Date?
        var maximumDate: Date?
        
        if sender.tag == 10086 { // 开始时间
            current = item?.startTime ?? Date()
            
            // 如果已经有结束时间，开始时间不能晚于结束时间
            if let endTime = item?.endTime {
                maximumDate = endTime
            }
            
            // 可以设置一个绝对最小值，比如今天之前不早于某个日期
            minimumDate = FiltrateConfiguration.default.customMinimumDate
            
        } else { // 结束时间
            current = item?.endTime ?? Date()
            
            // 如果已经有开始时间，结束时间不能早于开始时间
            if let startTime = item?.startTime {
                minimumDate = startTime
            }
            
            // 可以设置一个绝对最大值，比如不晚于今天
             maximumDate = FiltrateConfiguration.default.customMaximumDate
        }
        
        DatePickerView()
            .title(sender.tag == 10086 ? "选择开始时间" : "选择结束时间")
            .datePickerMode(.date)
            .currentDate(current)
            .minimumDate(minimumDate)
            .maximumDate(maximumDate)
            .completion { [weak self] date in
                guard let self = self else { return }
                if sender.tag == 10086 {
                    self.item?.startTime = date
                    
                    // 如果开始时间修改后大于结束时间，自动调整结束时间
                    if let endTime = self.item?.endTime, date > endTime {
                        self.item?.endTime = date
                        self.showToast(message: "开始时间已调整，结束时间自动更新")
                    }
                } else {
                    self.item?.endTime = date
                    
                    // 如果结束时间修改后小于开始时间，自动调整开始时间
                    if let startTime = self.item?.startTime, date < startTime {
                        self.item?.startTime = date
                        self.showToast(message: "结束时间已调整，开始时间自动更新")
                    }
                }
                self.updateUI()
            }
            .actionSheet()
    }
    
    // 显示提示信息
    func showToast(message: String, duration: TimeInterval = 2.0) {
        debugPrint("")
    }
    
    func updateUI() {
        guard let item = item else { return }
        // 创建日期格式化器
        let formatter = DateFormatter()
        // 设置地区为中国上海（中文）
        formatter.locale = Locale(identifier: "zh_CN")  // 中文简体
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")  // 上海时区
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = item.startTime, let button = viewWithTag(10086) as? UnfoldButton {
            button.titleLabel.text = formatter.string(from: date)
        }
        
        if let date = item.endTime, let button = viewWithTag(10087) as? UnfoldButton {
            button.titleLabel.text = formatter.string(from: date)
        }
    }
}
