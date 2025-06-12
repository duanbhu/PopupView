//
//  Untitled.swift
//  Pods
//
//  Created by Duanhu on 2025/6/12.
//
import UIKit
import SwiftMessages

// MARK: - 取消、确定按钮
nonisolated(unsafe) fileprivate var DHButtonStackContext: UInt8 = 0

@MainActor
public protocol ButtonStackable {
    var buttonStackView: UIStackView { get }
}

public extension ButtonStackable {
    var buttonStackView: UIStackView {
        if let imageView = objc_getAssociatedObject(self, &DHButtonStackContext) as? UIStackView {
            return imageView
        } else {
            let view = createButtonStackView()
            objc_setAssociatedObject(self, &DHButtonStackContext, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
    }
    
    func createButtonStackView() -> UIStackView {
        let view = UIStackView(arrangedSubviews: [])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = PopupConfiguration.default().buttonSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

public extension ButtonStackable {
    typealias Handle = (Self) -> ()
    
    @discardableResult
    func layoutButtonStack(left: CGFloat, right: CGFloat, bottom: CGFloat, height: CGFloat, at view: UIView) -> Self {
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -right),
            buttonStackView.heightAnchor.constraint(equalToConstant: height),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom),
        ])
        return self
    }
    
    @discardableResult
    func layoutButtonStack(insetsX: CGFloat, bottom: CGFloat, height: CGFloat, at view: UIView) -> Self  {
        layoutButtonStack(left: insetsX, right: insetsX, bottom: bottom, height: height, at: view)
    }
    
    @discardableResult
    func addAction(_ parts: LabelButtonConfig.Part... , handel: Handle? = nil) -> Self {
        let config = LabelButtonConfig(parts)
        return addAction(config: config, handel: handel)
    }
    
    @discardableResult
    func addAction(_ title: String? = nil, config: LabelButtonConfig, handel: Handle? = nil) -> Self {
        let button = UIButton(config: config)
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        return addButton(button, handel: handel)
    }
    
    @discardableResult
    func addButton(_ button: UIButton, handel: Handle? = nil) -> Self {
        buttonStackView.addArrangedSubview(button)
        button.addActionBlock { sender in
            if handel == nil, let _ = self as? PopupView {
                SwiftMessages.hide()
            }
            handel?(self)
        }
        return self
    }
}

// MARK: - show
public enum PopupPosition {
    case center, bottom
}

public protocol Popupable: UIView {
    typealias DidHideHandle = () -> ()
}

public extension Popupable {
    /// 弹窗拉起
    /// - Parameters:
    ///   - isDismissTapMask: true: 点击背景弹窗消失。 默认为false
    ///   - level: UIWindow.Level
    ///   - didHideHandle: 弹窗消失时的回调
    func show(position: PopupPosition, isDismissTapMask: Bool = false, level: UIWindow.Level = .alert, didHideHandle: DidHideHandle? = nil) {
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationContext = .window(windowLevel: level)
        switch position {
        case .center:
            config.presentationStyle = .center
        case .bottom:
            config.presentationStyle = .bottom
        }
        config.dimMode = .gray(interactive: isDismissTapMask)
        config.eventListeners.append() { event in
            if case .didHide = event {
                didHideHandle?()
            }
        }
        SwiftMessages.show(config: config, view: self)
    }
}
