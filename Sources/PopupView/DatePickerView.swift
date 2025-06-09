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
        contentStackView.addArrangedSubview(datePicker)
    }
    
    override func resetDef() {
        datePicker.date = self.default ?? Date()
    }
    
    override func confirmAction(_ sender: UIButton) {
        
        super.confirmAction(sender)
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
