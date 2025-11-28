
import SwiftMessages
import UIKit

/// SwiftEntryKit
public extension PopupView {
    struct PositionConstraints {
        
        /** Describes safe area relation */
        public enum SafeArea {
            
            /** Entry overrides safe area */
            case overridden
            
            /** The entry shows outs. But can optionally be colored */
            case empty(fillSafeArea: Bool)
            
            public var isOverridden: Bool {
                switch self {
                case .overridden:
                    return true
                default:
                    return false
                }
            }
        }
        
        /** Describes an edge constraint of the entry */
        public enum Edge {
            
            /** Ratio constraint to screen edge */
            case ratio(value: CGFloat)
            
            /** Offset from each edge of the screen */
            case offset(value: CGFloat)
            
            /** Constant edge length */
            case constant(value: CGFloat)
            
            /** Unspecified edge length */
            case intrinsic
            
            /** Edge totally filled */
            public static var fill: Edge {
                return .offset(value: 0)
            }
        }
        
        /** Describes the size of the entry */
        public struct Size {
            
            /** Describes a width constraint */
            public var width: Edge
            
            /** Describes a height constraint */
            public var height: Edge
            
            /** Initializer */
            public init(width: Edge, height: Edge) {
                self.width = width
                self.height = height
            }
            
            /** The content's size. Entry's content view must have tight constraints */
            public static var intrinsic: Size {
                return Size(width: .intrinsic, height: .intrinsic)
            }
            
            /** The content's size. Entry's content view must have tight constraints */
            public static var sizeToWidth: Size {
                return Size(width: .offset(value: 0), height: .intrinsic)
            }
            
            /** Screen size, without horizontal or vertical offset */
            public static var screen: Size {
                return Size(width: .fill, height: .fill)
            }
        }
        
        public enum VerticalPosition {
            case top, center, bottom
        }
        
        /** The size of the entry */
        public var size: Size
        
        /** The maximum size of the entry */
        public var maxSize: Size
        
        public var verticalPosition: VerticalPosition = .center

        /** The vertical offset from the top or bottom anchor */
        public var verticalOffset: CGFloat
        
        /** Can be used to display the content outside the safe area margins such as on the notch of the iPhone X or the status bar itself. */
        public var safeArea = SafeArea.empty(fillSafeArea: false)
        
        public var hasVerticalOffset: Bool {
            return verticalOffset > 0
        }
        
        /** Returns a floating entry (float-like) */
        public static var float: PositionConstraints {
            return PositionConstraints(verticalOffset: 10, size: .init(width: .offset(value: 16), height: .intrinsic))
        }
        
        /** A full width entry (toast-like) */
        public static var fullWidth: PositionConstraints {
            return PositionConstraints(verticalOffset: 0, size: .sizeToWidth)
        }
        
        /** A full screen entry - fills the entire screen, modal-like */
        public static var fullScreen: PositionConstraints {
            return PositionConstraints(verticalOffset: 0, size: .screen)
        }
        
        /** Initialize with default parameters */
        public init(verticalOffset: CGFloat = 0, size: Size = .sizeToWidth, maxSize: Size = .intrinsic) {
            self.verticalOffset = verticalOffset
            self.size = size
            self.maxSize = maxSize
        }
    }
}

open class PopupView: BasePopupView, ButtonStackable {
    /// message
    public lazy var messageLabel: UILabel = {
        let label = UILabel(config: PopupConfiguration.default().messageConfiguration)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    /// textField  输入窗
    public lazy var textField: UITextField = {
        let label = UITextField(config: PopupConfiguration.default().TFConfiguration)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// textField  count
    public lazy var countLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        // 抗拉伸（Content Hugging Priority）
        label.setContentHuggingPriority(.required, for: .horizontal)
        // 抗压缩（Content Compression Resistance Priority）
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    open override func makeUI() {
        super.makeUI()
    }
}

// MARK: - message
public extension PopupView {
    func messageLines(_ lines: Int) -> Self {
        messageLabel.numberOfLines = lines
        return self
    }
    
    @discardableResult
    func message(_ text: PopupStringType, insets: UIEdgeInsets = PopupConfiguration.default().bodyInsets) -> Self {
        if let string = text as? String {
            messageLabel.text = string
        } else if let attributedText = text as? NSAttributedString {
            messageLabel.attributedText = attributedText
        }
        installBodyContentView(messageLabel, insets: insets)
        return self
    }
    
    @discardableResult
    func TF(_ text: String? = nil, placeholder: String?, height: CGFloat = PopupConfiguration.default().TFHeight, insets: UIEdgeInsets = PopupConfiguration.default().bodyInsets) -> Self {
        textField.text = text
        textField.placeholder = placeholder
        
        let view = UIStackView(arrangedSubviews: [textField, countLabel])
        view.backgroundColor = textField.backgroundColor
        view.layer.cornerRadius = textField.layer.cornerRadius
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: height),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            countLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        installBodyContentView(view, insets: insets)
        return self
    }
    
    func updateTF(_ config: LabelButtonConfig) -> Self {
        textField.update(with: config)
        return self
    }
}
