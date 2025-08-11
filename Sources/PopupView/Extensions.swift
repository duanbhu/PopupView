//
//  StringExt.swift
//  PopupView
//
//  Created by Duanhu on 2025/6/10.
//

import Foundation
import UIKit

public extension String {
    // 计算单行文本宽度
    func singleLineWidth(font: UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font: font]
        return self.size(withAttributes:attrs as [NSAttributedString.Key: Any]).width
    }
}

public extension UIButton {
    /// 为按钮添加闭包事件处理器
    /// - Parameters:
    ///   - action: 点击时执行的闭包，参数为按钮本身
    ///   - event: 触发事件，默认为 `.touchUpInside`
    func addActionBlock(_ closure: @escaping (_ sender: UIButton) -> Void,
                            for event: UIControl.Event = .touchUpInside) {
        // 使用类型安全的关联对象包装器
        let target = ActionTarget(action: closure)
        objc_setAssociatedObject(self, &ActionTarget.key, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(target, action: #selector(ActionTarget.invoke(_:)), for: event)
    }
}

// 封装关联对象和事件处理的私有类
private final class ActionTarget {
    // 使用静态变量作为唯一键
    nonisolated(unsafe) fileprivate static var key: UInt8 = 0
    
    let action: (UIButton) -> Void
    
    init(action: @escaping (UIButton) -> Void) {
        self.action = action
    }
    
    @objc func invoke(_ sender: UIButton) {
        action(sender)
    }
}
