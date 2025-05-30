
import SwiftMessages
import UIKit

public extension PopupView {
    protocol MessageType {}
}

extension String: PopupView.MessageType {}
extension NSAttributedString: PopupView.MessageType {}

public class PopupView: BaseView {
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
    
    /// message
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        bodyView.addSubview(label)
        contentStackView.addArrangedSubview(bodyView)
        return label
    }()
    
    public lazy var bodyView: UIView = {
        let view = UIView()
        return view
    }()
    
    var buttonH: NSLayoutConstraint!
    public lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(view)
        view.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        buttonH = view.heightAnchor.constraint(equalToConstant: PopupConfiguration.default().buttonHeight)
        buttonH.isActive = true
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
    
    func makeUI() {
        cornerRoundingView.backgroundColor = .white
        cornerRoundingView.cornerRadius = 12
        cornerRoundingView.layer.masksToBounds = true
        installBackgroundView(cornerRoundingView, insets: backgroundInsets)
        installContentView(contentStackView, insets: contentViewInsets)
    }
    
    func show() {
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: self)
    }
    
    public func alert() {
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationContext = .window(windowLevel: .alert)
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: self)
    }
    
    public func actionSheet() {
        
        cornerRoundingView.roundedCorners = [.topLeft, .topRight]
        
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationContext = .window(windowLevel: .alert)
        config.presentationStyle = .bottom
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: self)
    }
}

// MARK: - title
public extension PopupView {
    @discardableResult
    func title(_ text: MessageType) -> Self {
        if let string = text as? String {
            titleLabel.text = string
        } else if let attributedText = text as? NSAttributedString {
            titleLabel.attributedText = attributedText
        } else {
            
        }
        return self
    }
    
    @discardableResult
    func titleHeight(_ h: CGFloat) -> Self {
        titleH.constant = h
        return self
    }
}

// MARK: - message
public extension PopupView {
    @discardableResult
    func message(_ text: MessageType, insets: UIEdgeInsets = PopupConfiguration.default().bodyInsets) -> Self {
        if let string = text as? String {
            messageLabel.text = string
        } else if let attributedText = text as? NSAttributedString {
            messageLabel.attributedText = attributedText
        }
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: insets.top),
            messageLabel.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: insets.left),
            messageLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -insets.right),
            messageLabel.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -insets.bottom),
        ])
        return self
    }
}

// MARK: - title
public extension PopupView {
    typealias Handle = (PopupView) -> ()
    
    @discardableResult
    func addAction(_ parts: LabelButtonConfig.Part... , handel: Handle? = nil) -> Self {
        let config = LabelButtonConfig(parts)
        return addAction(config: config, handel: handel)
    }
    
    @discardableResult
    func addAction(_ title: String? = nil, config: LabelButtonConfig, handel: Handle? = nil) -> Self {
        let button = UIButton(config: config)
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        return addButton(button, handel: handel)
    }
    
    @discardableResult
    func addButton(_ button: UIButton, handel: Handle? = nil) -> Self {
        buttonStackView.addArrangedSubview(button)
        button.addActionBlock { sender in
            if handel == nil {
                SwiftMessages.hide()
            }
            handel?(self)
        }
        return self
    }
}

@MainActor fileprivate var UIButtonActionKeyContext: UInt8 = 0
extension UIButton {
   
    func addActionBlock(_ closure: @escaping (_ sender: UIButton) -> Void,
                            for controlEvents: UIControl.Event = .touchUpInside) {
        //把闭包作为一个值 先保存起来
        objc_setAssociatedObject(self, &UIButtonActionKeyContext, closure, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        //给按钮添加传统的点击事件，调用写好的方法
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
