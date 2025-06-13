
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
    
    public var borderColor: UIColor?
    
    public var cornerRadius: CGFloat?
    
    public override init() {}
    
    static public var cancel: LabelButtonConfig {
        return cancel()
    }
    
    static public var confirm: LabelButtonConfig {
        return confirm()
    }
    
    public static func cancel(radius: CGFloat? = nil) -> LabelButtonConfig {
        let config = PopupConfiguration.default().cancelConfiguration
        config.update(part: .cornerRadius(radius))
        return config
    }
    
    public static func confirm(radius: CGFloat? = nil) -> LabelButtonConfig {
        let config = PopupConfiguration.default().confirmConfiguration
        config.update(part: .cornerRadius(radius))
        return config
    }
    
    public enum Part {
        case title(String?)
        case attributedTitle(NSAttributedString?)
        case icon(UIImage?)
        case font(UIFont)
        case titleColor(UIColor)
        case backgroundColor(UIColor)
        case borderColor(UIColor?)
        case cornerRadius(CGFloat?)
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
        case let .borderColor(color):
            self.borderColor = color
        case let .cornerRadius(radius):
            self.cornerRadius = radius
        }
    }
}

public extension UIButton {
    convenience init(config: LabelButtonConfig) {
        self.init(type: .custom)
        update(with: config, state: .normal)
    }
    
    func update(with config: LabelButtonConfig, state: UIControl.State) {
        self.setTitle(config.title, for: state)
        self.setTitleColor(config.titleColor, for: state)
        self.titleLabel?.font = config.font
        self.setImage(config.icon, for: state)
        self.backgroundColor = config.backgroundColor
        
        if let attributedTitle = config.attributedTitle {
            self.setAttributedTitle(attributedTitle, for: state)
        }
        view_update(with: config)
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
        view_update(with: config)
    }
}

extension UIView {
    func view_update(with config: LabelButtonConfig) {
        if let borderColor = config.borderColor {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 1
        }
        
        if let cornerRadius = config.cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
