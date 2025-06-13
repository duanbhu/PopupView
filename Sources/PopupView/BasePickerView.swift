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

public class BasePickerView<T>: BasePopupView, @preconcurrency PickerViewType {
    public typealias Item = T
    
    public var completion: ((Item) -> Void)?
    
    public var `default`: Item? {
        didSet {
            resetDef()
        }
    }
            
    public override func makeUI() {
        super.makeUI()
        makeTopActions()
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func makeTopActions() {
        titleLabel.isUserInteractionEnabled = true

        contentStackView.addArrangedSubview(buttonStackView)
        buttonStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        buttonStackSpacing(25)
        addAction(config: .cancel(radius: 5))
        addAction(config: .confirm(radius: 5)) { [weak self] popupView in
            self?.confirmAction()
        }
    }
    
    func resetDef() {
        
    }
    
    func confirmAction() {
        hide()
    }
}

extension BasePickerView: ButtonStackable {
    
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

