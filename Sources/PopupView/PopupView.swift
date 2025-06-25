
import SwiftMessages
import UIKit

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
        textField.heightAnchor.constraint(equalToConstant: height).isActive = true
        installBodyContentView(textField, insets: insets)
        return self
    }
    
    func updateTF(_ config: LabelButtonConfig) -> Self {
        textField.update(with: config)
        return self
    }
}
