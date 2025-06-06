
import SwiftMessages
import UIKit

public class PopupConfiguration: NSObject {

    nonisolated(unsafe) private static var single = PopupConfiguration()
    
    public class func `default`() -> PopupConfiguration {
        PopupConfiguration.single
    }
    
    public class func reset() {
        PopupConfiguration.single = PopupConfiguration()
    }
    
    public var backgroundInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    public var contentViewInsets = UIEdgeInsets.zero
        
    public var themeColor: UIColor = .black
    
    public var bodyInsets: UIEdgeInsets = .zero
    
    public var titleConfiguration = LabelButtonConfig()
    
    /// message的配置信息
    public var messageConfiguration = LabelButtonConfig()
    
    /// 按钮的高度
    public var buttonHeight: CGFloat = 44
    
    /// 按钮之间的间距
    public var buttonSpacing: CGFloat = 0
    
    /// 取消按钮
    public var cancelConfiguration = LabelButtonConfig()
    
    /// 确认按钮
    public var confirmConfiguration = LabelButtonConfig()
}

public class LabelButtonConfig: NSObject {
    public var title: String?
    
    public var attributedTitle: NSAttributedString?
    
    /// UIButton.image, 对label无效
    public var icon: UIImage?
    
    public var font: UIFont = .systemFont(ofSize: 16)
    
    public var backgroundColor: UIColor = .clear
    
    public var titleColor: UIColor = .black
    
    public override init() {}
    
    static public var cancel: LabelButtonConfig {
        return PopupConfiguration.default().cancelConfiguration
    }
    
    static public var confirm: LabelButtonConfig {
        return PopupConfiguration.default().confirmConfiguration
    }
    
    public enum Part {
        case title(String?)
        case attributedTitle(NSAttributedString?)
        case icon(UIImage?)
        case font(UIFont)
        case titleColor(UIColor)
        case backgroundColor(UIColor)
    }
    
    public convenience init(_ parts: Part...) {
        self.init(parts)
    }
    
    /// Create a `StringStyle` from an array of parts
    ///
    /// - Parameter parts: An array of `StylePart`s
    public convenience init(_ parts: [Part]) {
        self.init()
        for part in parts {
            update(part: part)
        }
    }
    
    public func update(part stylePart: Part) {
        switch stylePart {
        case let .title(title):
            self.title = title
        case let .attributedTitle(attr):
            self.attributedTitle = attr
        case let .font(font):
            self.font = font
        case let .backgroundColor(backgroundColor):
            self.backgroundColor = backgroundColor
        case let .titleColor(color):
            self.titleColor = color
        case .icon(let icon):
            self.icon = icon
        }
    }
}

public extension UIButton {
    convenience init(config: LabelButtonConfig) {
        self.init(type: .custom)
        update(with: config)
    }
    
    func update(with config: LabelButtonConfig) {
        self.setTitle(config.title, for: .normal)
        self.setTitleColor(config.titleColor, for: .normal)
        self.titleLabel?.font = config.font
        self.setImage(config.icon, for: .normal)
        self.backgroundColor = config.backgroundColor
        
        if let attributedTitle = config.attributedTitle {
            self.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
}

public extension UILabel {
    convenience init(config: LabelButtonConfig) {
        self.init()
        update(with: config)
    }
    
    func update(with config: LabelButtonConfig) {
        self.text = config.title
        self.font = config.font
        self.textColor = config.titleColor
        self.backgroundColor = config.backgroundColor
        if let attributedTitle = config.attributedTitle {
            self.attributedText = attributedTitle
        }
    }
}
