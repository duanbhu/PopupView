//
//  Untitled.swift
//  Pods
//
//  Created by Duanhu on 2025/6/12.
//
import UIKit
import SwiftMessages

public protocol PopupStringType { }

extension String: PopupStringType {}

extension NSAttributedString: PopupStringType {}

// MARK: - title 两侧的按钮
nonisolated(unsafe) fileprivate var PopupTopBarLeftButtonContext: UInt8 = 0
nonisolated(unsafe) fileprivate var PopupTopBarRightButtonContext: UInt8 = 0

@MainActor
public protocol PopupTopBarActionable: BasePopupView {
    
    var leftButton: UIButton { get }
    
    var rightButton: UIButton { get }
}

public extension PopupTopBarActionable {
    var leftButton: UIButton {
        if let view = objc_getAssociatedObject(self, &PopupTopBarLeftButtonContext) as? UIButton {
            return view
        } else {
            let view = createButton()
            view.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            objc_setAssociatedObject(self, &PopupTopBarLeftButtonContext, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
    }
    
    var rightButton: UIButton {
        if let view = objc_getAssociatedObject(self, &PopupTopBarRightButtonContext) as? UIButton {
            return view
        } else {
            let view = createButton()
            view.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
            objc_setAssociatedObject(self, &PopupTopBarRightButtonContext, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
    }
    
    private func createButton() -> UIButton {
        let view = UIButton(type: .custom)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            view.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 64)
        ])
        return view
    }
    
    @discardableResult
    func leftTitle(_ title: String, color: UIColor, action: @escaping (_ sender: UIButton) -> Void) -> Self {
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(color, for: .normal)
        leftButton.addActionBlock(action)
        return self
    }
    
    @discardableResult
    func leftImage(_ image: UIImage?, action: @escaping (_ sender: UIButton) -> Void) -> Self {
        leftButton.setImage(image, for: .normal)
        leftButton.addActionBlock(action)
        return self
    }
    
    @discardableResult
    func leftImage(_ imageNamed: String, action: @escaping (_ sender: UIButton) -> Void) -> Self {
        leftButton.setImage(UIImage(named: imageNamed), for: .normal)
        leftButton.addActionBlock(action)
        return self
    }
    
    @discardableResult
    func rightTitle(_ title: String, color: UIColor, action: @escaping (_ sender: UIButton) -> Void) -> Self {
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(color, for: .normal)
        rightButton.addActionBlock(action)
        return self
    }
    
    @discardableResult
    func rightImage(_ image: UIImage?, action: @escaping (_ sender: UIButton) -> Void) -> Self {
        rightButton.setImage(image, for: .normal)
        rightButton.addActionBlock(action)
        return self
    }
    
    @discardableResult
    func rightImage(_ imageNamed: String, action: @escaping (_ sender: UIButton) -> Void) -> Self {
        rightButton.setImage(UIImage(named: imageNamed), for: .normal)
        rightButton.addActionBlock(action)
        return self
    }
}

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
    func buttonStackSpacing(_ spacing: CGFloat) -> Self {
        buttonStackView.spacing = spacing
        return self
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
            if handel == nil, let _ = self as? BasePopupView {
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
    @discardableResult
    func show(_ position: PopupPosition, isDismissTapMask: Bool = false, level: UIWindow.Level = .alert, didHideHandle: DidHideHandle? = nil) -> Self {
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationContext = .window(windowLevel: level)
        switch position {
        case .center:
            config.presentationStyle = .center
        case .bottom:
            if let view = self as? BasePopupView {
                view.cornerRoundingView.roundedCorners = [.topLeft, .topRight]
            }
            config.presentationStyle = .bottom
        }
        config.dimMode = .gray(interactive: isDismissTapMask)
        config.eventListeners.append() { event in
            if case .didHide = event {
                didHideHandle?()
            }
        }
        SwiftMessages.show(config: config, view: self)
        return self
    }
    
    /// 中间弹出
    @discardableResult
    func alert() -> Self {
        return show(.center)
    }
    
    /// 底部弹出
    @discardableResult
    func actionSheet() -> Self {
        return show(.bottom)
    }
}
