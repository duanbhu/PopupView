//
//  FiltrateSection.swift
//  MobileExt
//
//  Created by Duanhu on 2024/4/17.
//

import UIKit

public class FiltrateConfiguration: NSObject {
    nonisolated(unsafe) private static var single = FiltrateConfiguration()
    
    public static var `default`: FiltrateConfiguration {
        FiltrateConfiguration.single
    }
    
    /// 是否需要显示自定义的日期底部视图
    public var isNeedShowCustomDateFooterHandle: ((FiltrateHeaderItemViewModel, FiltrateItemViewModel?) -> Bool)? = nil
    
    public var themeColor: UIColor = .orange
    
    /// 底部按钮的高度
    public var buttonHeight: CGFloat = 54
    
    /// 按钮之间的间距
    public var buttonSpacing: CGFloat = 0
    
    /// 重置按钮
    public var resetConfiguration = LabelButtonConfig()
    
    /// 确认按钮
    public var confirmConfiguration = LabelButtonConfig()
    
    /// 根据key构建sectionModel
    public var buildSectionModel: ((FilterParameterKeyable, Bool) -> [FiltrateSectionModel])?
}

public struct FiltrateSectionModel {
    public var header: FiltrateHeaderItemViewModel
    
    public var items: [FiltrateItemViewModel]
    
    public init(header: FiltrateHeaderItemViewModel, items: [FiltrateItemViewModel]) {
        self.header = header
        self.items = items
    }
}

public class FiltrateHeaderItemViewModel: NSObject {
    /// 这个secton对应的key
    public var key: FilterParameterKeyable? = nil
    
    /// 区别业务中，items会随着业务场景删减
    public var alias: String? = nil
            
    public var config: LabelButtonConfig = LabelButtonConfig(
        .font(.boldSystemFont(ofSize: 16)),
        .titleColor(.black)
    )
        
    public var sectionInset: UIEdgeInsets = .zero
    
    /// herder View 高度
    public var height: CGFloat = 0
    
    /// 行间距
    public var lineSpacing: CGFloat = 8
    
    /// 列间距
    public var itemSpacing: CGFloat = 8
    
    /// 是否显示 - 选择日期
    public var showDatePick = false
    
    /// 开始时间
    public var startTime: Date?
    
    /// 结束时间
    public var endTime: Date?
    
    /// 是否允许多选  默认不允许
    public var allowMultiSelect: Bool = false
    
    public override init() {
        self.startTime = Date()
        self.endTime = Date()
    }
}

public extension FiltrateHeaderItemViewModel {
    @discardableResult
    func key(_ key: FilterParameterKeyable?) -> Self {
        self.key = key
        return self
    }
    
    @discardableResult
    func title(_ title: String?) -> Self {
        self.config.update(part: .title(title))
        return self
    }
    
    @discardableResult
    func sectionInset(_ inset: UIEdgeInsets) -> Self {
        self.sectionInset = inset
        return self
    }
    
    @discardableResult
    func sectionInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        self.sectionInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat) -> Self {
        self.height = height
        return self
    }
    
    @discardableResult
    func lineSpacing(_ spacing: CGFloat) -> Self {
        self.lineSpacing = spacing
        return self
    }
    
    @discardableResult
    func itemSpacing(_ spacing: CGFloat) -> Self {
        self.itemSpacing = spacing
        return self
    }
    
    @discardableResult
    func allowMultiSelect(_ bool: Bool) -> Self {
        self.allowMultiSelect = bool
        return self
    }
}

public protocol FiltrateItemType {
    var id: String? { get }
    
    var title: String? { get }
    
    static func items(for alias: String?) -> [Self]
}

public class FiltrateItemViewModel: NSObject {
    public var id: String?
    
    public var config: LabelButtonConfig = LabelButtonConfig(
        .font(.systemFont(ofSize: 13)),
        .backgroundColor(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)),
        .titleColor(.black)
    )
    
    public var selectConfig: LabelButtonConfig = LabelButtonConfig(
        .font(.boldSystemFont(ofSize: 13)),
        .backgroundColor(FiltrateConfiguration.default.themeColor),
        .titleColor(.white)
    )
            
    /// itemSize.width,  默认为0时，会自动计算宽度： 文字宽度 + 2*increaseWidth*
    public var width: CGFloat = 0
    
    /// width 为0时，会根据title文本计算宽度， 增加宽度
    public var increaseWidth: CGFloat = 10
    
    /// itemSize.height
    public var height: CGFloat = 35
    
    /// 允许点击
    public var allowSelection: Bool = true
    
    /// 是否属于选中状态
    public var isSelected: Bool = false
    
    /// 多选时，是否排斥其他选项,   true：即选择该项后， 同section下， 已勾选的则取消勾选。 默认false
    public var isRepelWhenMultiSelect: Bool = false
    
    func authWidth() -> CGFloat {
        if width > 0 {
            return width
        }
        // 计算文本宽度
        let title = config.title
        let attrs = [NSAttributedString.Key.font: selectConfig.font]
        let width = title?.size(withAttributes:attrs as [NSAttributedString.Key: Any]).width ?? 0
        self.width = width + CGFloat(2) * increaseWidth
        return self.width
    }
    
    public init(item: FiltrateItemType) {
        super.init()
        self.id(item.id)
        self.config.update(part: .title(item.title))
    }
}

public extension FiltrateItemViewModel {
    @discardableResult
    func id(_ id: String?) -> Self {
        self.id = id
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        self.width = width
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat) -> Self {
        self.height = height
        return self
    }
    
    @discardableResult
    func allowSelection(_ allowSelection: Bool) -> Self {
        self.allowSelection = allowSelection
        return self
    }
    
    @discardableResult
    func isSelected(_ isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }
}
