//
//  StringPickerView.swift
//  Posthouse_iOS
//
//  Created by Duanhu on 2023/10/26.
//

import UIKit

public protocol PickerOptionalType: Equatable {
    var title: String { get }
}

extension String: PickerOptionalType {
    public var title: String { self }
}

// 多列之间，不联动
public class StringPickerView<Element: PickerOptionalType>: BasePickerView<Element>, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// 多列时，选中完成回调
    public var multiComponentCompletion: (([Element]) -> Void)?
    
    public var defaults: [Element] = [] {
        didSet {
            resetDef()
        }
    }
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    let items: [[Element]]
    
    public init(items: [[Element]]) {
        self.items = items
        super.init(backgroundInsets: .zero, contentViewInsets: .zero)
    }
    
    public convenience init(items: [Element]) {
        self.init(items: [items])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func makeUI() {
        super.makeUI()
        pickerView.heightAnchor.constraint(equalToConstant: 216).isActive = true
        contentStackView.insertArrangedSubview(pickerView, at: 1)
    }
    
    override func resetDef() {
        if let def = self.default, let idx = items[0].firstIndex(of: def) {
            // 单列
            pickerView.selectRow(idx, inComponent: 0, animated: false)
        }
        
        guard !defaults.isEmpty else { return }
        // 多列
        for (idx, componentItems) in items.enumerated() {
            guard idx < defaults.count, let row = componentItems.firstIndex(of: defaults[idx]) else { break }
            pickerView.selectRow(row, inComponent: idx, animated: false)
        }
    }
    
    override func confirmAction() {
        // 单列
        if items.count == 1 {
            completion?(items[0][pickerView.selectedRow(inComponent: 0)])
        } else if items.count > 1 {
            // 多列时回调
            multiComponentCompletion?((0..<items.count).map { items[$0][pickerView.selectedRow(inComponent: $0)] })
        }
        super.confirmAction()
    }
    
    // MARK: - UIPickerViewDelegate, UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return items.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[component][row].title
    }
    
    @discardableResult
    public func defaultItems(_ items: [Element]) -> Self {
        self.defaults = items
        return self
    }
    
    @discardableResult
    public func multiComponentCompletion(_ completion: (([Element]) -> Void)?) -> Self {
        self.multiComponentCompletion = completion
        return self
    }
}
