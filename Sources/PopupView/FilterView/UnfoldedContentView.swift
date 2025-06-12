//
//  UnfoldedFiltrateView.swift
//  PopupView
//
//  Created by Duanhu on 2025/6/10.
//

import UIKit

open class BackgroundMaskView: UIView {
    /// 不被遮罩的区域, 挖洞
    var ignoreRect = CGRect.zero
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // true：当用户点击背景时，起到拦截事件的作用； false时， 事件会传递给下一个视图，这里不允许设置为false
        isUserInteractionEnabled = true
        makeUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        backgroundColor = .init(white: 0, alpha: 0.3)
    }
    
    // 不被遮罩的区域
    @discardableResult
    open func ignoreRect(_ holeRect: CGRect) -> Self {
        ignoreRect = holeRect
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: self.bounds)
        
        let whitePath = UIBezierPath(roundedRect: holeRect, cornerRadius: 8)
        path.append(whitePath.reversing())
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        return self
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isUserInteractionEnabled || self.alpha <= 0.01 || self.isHidden {
            return nil
        }
        
        if ignoreRect.contains(point) {
            return nil
        }
        return super.hitTest(point, with: event)
    }
}

open class UnfoldedContentView: UIView {

    /// 半透明遮罩
    lazy var backgroundMask: BackgroundMaskView = {
        let view = BackgroundMaskView(frame: UIScreen.main.bounds)
        return view
    }()

    public lazy var collectionView: FiltrateCollectionView = {
        let view = FiltrateCollectionView(frame: self.bounds)
        return view
    }()
    
    public var sectionModels: [FiltrateSectionModel] = [] {
        didSet {
            collectionView.sections = sectionModels
            collectionView.updateHeight()
        }
    }
    
    public var bottomInset: CGFloat = 0
    
    public var senderHeight: CGFloat = 62
    
    public var isHideWhenTapMask = true
    
    public var didHideHandle: (()->())?
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func makeUI() {
        collectionView.layer.cornerRadius = 8
        collectionView.layer.masksToBounds = true
        addSubview(collectionView)
        // 点击背景，取消扩展区
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMask))
        backgroundMask.isUserInteractionEnabled = true
        backgroundMask.addGestureRecognizer(tap)
    }
    
    open func config(sectionModels: [FiltrateSectionModel], sender: UIView, at container: UIView) {
        senderHeight = sender.frame.height
        collectionView.frame = CGRect(x: 0, y: sender.frame.height, width: frame.width, height: 104)
        
        guard let superview = sender.superview else { return }
        self.sectionModels = sectionModels
        
        let senderFrame = superview.convert(sender.frame, to: container)
        var rect = self.frame
        rect.origin = senderFrame.origin
        rect.size.height = collectionView.frame.height + collectionView.frame.minY + bottomInset
        self.frame = rect
        backgroundMask.ignoreRect(rect)
    }
    
    open func show(sectionModels: [FiltrateSectionModel], sender: UIView, at container: UIView) {
        config(sectionModels: sectionModels, sender: sender, at: container)
        
        if !container.subviews.contains(backgroundMask) {
            container.addSubview(backgroundMask)
        }
        
        if !container.subviews.contains(self) {
            container.addSubview(self)
        }
    }
    
    @objc func tapMask() {
        guard isHideWhenTapMask else { return }
        hide()
    }
    
    open func hide() {
        removeFromSuperview()
        backgroundMask.removeFromSuperview()
        didHideHandle?()
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let senderRect = CGRect(x: 0, y: 0, width: frame.width, height: senderHeight)
        if senderRect.contains(point) {
            // 下一层的视图继续响应
            return nil
        }
        return super.hitTest(point, with: event)
    }
}
