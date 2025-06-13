
import SwiftMessages
import UIKit

open class BasePopupView: BaseView, Popupable {
    public lazy var cornerRoundingView: CornerRoundingView = {
        let view = CornerRoundingView()
        return view
    }()
    
    public lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [])
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleH: NSLayoutConstraint!
    
    /// title
    public lazy var titleLabel: UILabel = {
        let label = UILabel(config: PopupConfiguration.default().titleConfiguration)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        contentStackView.insertArrangedSubview(label, at: 0)
        titleH = label.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([
            titleH,
            label.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)
        ])
        return label
    }()
    
    public lazy var bodyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(view)
        return view
    }()
    
    public lazy var safeView: UIView = {
        let view = UIView()
        return view
    }()
    
    let backgroundInsets: UIEdgeInsets
    
    let contentViewInsets: UIEdgeInsets
    
    public init(
        backgroundInsets: UIEdgeInsets = PopupConfiguration.default().backgroundInsets,
        contentViewInsets: UIEdgeInsets = PopupConfiguration.default().contentViewInsets
    ) {
        self.backgroundInsets = backgroundInsets
        self.contentViewInsets = contentViewInsets
        super.init(frame: .zero)
        makeUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.backgroundInsets = .zero
        self.contentViewInsets = .zero
        super.init(coder: aDecoder)
        makeUI()
    }
    
    open func makeUI() {
        cornerRoundingView.backgroundColor = .white
        cornerRoundingView.cornerRadius = 12
        cornerRoundingView.layer.masksToBounds = true
        installBackgroundView(cornerRoundingView, insets: backgroundInsets)
        installContentView(contentStackView, insets: contentViewInsets)
    }
    
    open func installBodyContentView(_ view: UIView, insets: UIEdgeInsets) {
        view.translatesAutoresizingMaskIntoConstraints = false
        bodyView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -insets.right),
            view.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -insets.bottom),
        ])
    }
    
    open func hide(animated: Bool = true) {
        SwiftMessages.hide(animated: animated)
    }
}

public extension BasePopupView {
    /// 设置圆角
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        cornerRoundingView.cornerRadius = cornerRadius
        return self
    }
    
    @discardableResult
    func title(_ text: PopupStringType) -> Self {
        if let string = text as? String {
            titleLabel.text = string
        } else if let attributedText = text as? NSAttributedString {
            titleLabel.attributedText = attributedText
        }
        return self
    }
    
    @discardableResult
    func titleHeight(_ h: CGFloat) -> Self {
        titleH.constant = h
        return self
    }
}
