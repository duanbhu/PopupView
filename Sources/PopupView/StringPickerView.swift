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
    public var title: String {
        self
    }
}

/// 目前仅实现了单列的
public class StringPickerView<Element: PickerOptionalType>: BasePickerView<Element>, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    let items: [Element]
    
    public init(items: [Element]) {
        self.items = items
        super.init(backgroundInsets: .zero, contentViewInsets: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func makeUI() {
        super.makeUI()
        pickerView.heightAnchor.constraint(equalToConstant: 216).isActive = true
        contentStackView.addArrangedSubview(pickerView)
    }
    
    override func resetDef() {
        if let def = self.default, let idx = items.firstIndex(of: def) {
            // 单列
            pickerView.selectRow(idx, inComponent: 0, animated: false)
        }
//        else if let items = items as? [[String]], let defs = self.default as? [String] {
//            // 多列
//            for ((idx, componentItems), def) in zip(items.enumerated(), defs) {
//                guard let row = componentItems.firstIndex(of: def) else { break }
//                pickerView.selectRow(row, inComponent: idx, animated: false)
//            }
//        }
    }
    
    override func confirmAction(_ sender: UIButton) {
        // 单列
        completion?(items[pickerView.selectedRow(inComponent: 0)])
        super.confirmAction(sender)
    }
    
    // MARK: - UIPickerViewDelegate, UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].title
    }
}
