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

nonisolated(unsafe) fileprivate var UIButtonActionKeyContext: UInt8 = 0
public extension UIButton {
    /// 给按钮添加闭包事件
    func addActionBlock(_ closure: @escaping (_ sender: UIButton) -> Void,
                            for controlEvents: UIControl.Event = .touchUpInside) {
        objc_setAssociatedObject(self, &UIButtonActionKeyContext, closure, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        self.addTarget(self, action: #selector(my_ActionForTapGesture), for: controlEvents)
    }
    
    @objc private func my_ActionForTapGesture() {
        //获取闭包值
        let obj = objc_getAssociatedObject(self, &UIButtonActionKeyContext)
        if let action = obj as? (_ sender:UIButton)->() {
            //调用闭包
            action(self)
        }
    }
}
