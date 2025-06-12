//
//  UnfoldedFiltrateView.swift
//  PopupView
//
//  Created by Duanhu on 2025/6/10.
//

import UIKit

import UIKit

open class BackgroundMaskView: UIView {
    /// 不被遮罩的区域, 挖洞
    var ignoreRect = CGRect.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
        if ignoreRect.contains(point) {
            return nil
        }
        return super.hitTest(point, with: event)
    }
}

open class UnfoldedContentView: UIView {

    /// 半透明遮罩
    public lazy var backgroundMask: BackgroundMaskView = {
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
    
    var senderHeight: CGFloat = 62
    
    var dismissCompletion: (()->())?
        
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
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
        rect.size.height = collectionView.frame.height + collectionView.frame.minY
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
    
    @objc
    public func hide() {
        removeFromSuperview()
        backgroundMask.removeFromSuperview()
        dismissCompletion?()
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let ignoreRect = CGRect(x: 0, y: 0, width: self.frame.width, height: senderHeight)
        if ignoreRect.contains(point) {
            return nil
        }
        return super.hitTest(point, with: event)
    }
}
