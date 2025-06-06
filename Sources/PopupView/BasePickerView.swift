//
//  BasePickerView.swift
//  Posthouse_iOS
//
//  Created by Duanhu on 2023/7/27.
//

import UIKit
import SwiftMessages

public protocol PickerViewType {
    associatedtype Item
    
    var completion: ((Item) -> Void)? { get set }
    
    var `default`: Item? { get set }
}

public extension BasePickerView {
    enum ActionPostion {
        case top, bottom
    }
}

public class BasePickerView<T>: PopupView, @preconcurrency PickerViewType {
    public typealias Item = T
    
    public var completion: ((Item) -> Void)?
    
    public var `default`: Item? {
        didSet {
            resetDef()
        }
    }
    
    // MARK: - private lazy var UI
    private(set) lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("确认", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return button
    }()
        
    public override func makeUI() {
        super.makeUI()
        makeTopActions()
        
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func makeTopActions() {
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addSubview(cancelButton)
        titleLabel.addSubview(confirmButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            cancelButton.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            cancelButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 64),
            
            confirmButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            confirmButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 64)
        ])
    }
    
    func resetDef() {
        
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        SwiftMessages.hide()
    }
    
    @objc func confirmAction(_ sender: UIButton) {
        SwiftMessages.hide()
    }
}

public extension BasePickerView {
    @discardableResult
    func defaultItem(_ item: T?) -> Self {
        self.default = item
        return self
    }
    
    @discardableResult
    func completion(_ callback: ((Item) -> Void)?) -> Self {
        self.completion = callback
        return self
    }
}

