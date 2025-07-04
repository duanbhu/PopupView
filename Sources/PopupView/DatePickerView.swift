//
//  DatePickerView.swift
//  Posthouse_iOS
//
//  Created by Duanhu on 2023/7/27.
//

import UIKit

public class DatePickerView: BasePickerView<Date> {
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "zh")
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return datePicker
    }()
    
    public init() {
        super.init(backgroundInsets: .zero, contentViewInsets: .zero)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func makeUI() {
        super.makeUI()
        datePicker.heightAnchor.constraint(equalToConstant: 216).isActive = true
        contentStackView.insertArrangedSubview(datePicker, at: 1)
    }
    
    override func resetDef() {
        datePicker.date = self.default ?? Date()
    }
    
    override func confirmAction() {
        completion?(datePicker.date)
        super.confirmAction()
    }
}

public extension DatePickerView {
    @discardableResult
    func datePickerMode(_ mode: UIDatePicker.Mode) -> Self {
        datePicker.datePickerMode = mode
        return self
    }
    
    @discardableResult
    func minimumDate(_ date: Date?) -> Self {
        datePicker.minimumDate = date
        return self
    }
    
    @discardableResult
    func maximumDate(_ date: Date?) -> Self {
        datePicker.maximumDate = date
        return self
    }
    
    @discardableResult
    func currentDate(_ date: Date) -> Self {
        datePicker.date = date
        return self
    }
}

public extension DatePickerView {
    static func showYearMonths(title: String = "选择时间", current: Date = Date(), completion: @escaping (Date) -> ()) {
        if #available(iOS 17.4, *) {
            DatePickerView()
                .title(title)
                .datePickerMode(.yearAndMonth)
                .currentDate(current)
                .completion({ item in
                    debugPrint("选择： \(item)")
                    completion(item)
                })
                .actionSheet()
        } else {
            var years: [String] = []
            for idx in 2020..<2120 {
                let hour = String(format: "%d年", idx)
                years.append(hour)
            }
            
            var months: [String] = []
            for idx in 1..<13 {
                let hour = String(format: "%d月", idx)
                months.append(hour)
            }
            let timeZone = TimeZone(identifier: "Asia/Shanghai")! // 设置时区为上海时间
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = timeZone
        
            let year = calendar.component(.year, from: current)
            let month = calendar.component(.month, from: current)
            StringPickerView(items: [years, months])
                .defaultItems(["\(year)年", "\(month)月"])
                .title(title)
                .multiComponentCompletion({ selets in
                    // 1. 定义格式化器（根据中文日期格式）
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "zh_CN") // 确保中文环境
                    formatter.timeZone = timeZone
                    formatter.dateFormat = "yyyy年M月"
                    formatter.calendar = calendar
                    let date = formatter.date(from: selets.joined()) ?? current
                    completion(date)
                })
                .actionSheet()
        }
    }
}
