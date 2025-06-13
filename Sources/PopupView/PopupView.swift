
import SwiftMessages
import UIKit

open class PopupView: BasePopupView, ButtonStackable {
    /// message
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var buttonH: NSLayoutConstraint!
    public lazy var buttonStackView: UIStackView = {
        let view = createButtonStackView()
        contentStackView.addArrangedSubview(view)
        view.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        buttonH = view.heightAnchor.constraint(equalToConstant: PopupConfiguration.default().buttonHeight)
        buttonH.isActive = true
        return view
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
}
