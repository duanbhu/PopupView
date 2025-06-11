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

