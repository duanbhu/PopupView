
import SwiftMessages
import UIKit

open class BasePopupView: BaseView {
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
    
    open func makeUI() {
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
