//
//  UnfoldButton.swift
//  PopupView
//
//  Created by Duanhu on 2025/6/10.
//

import UIKit

public class UnfoldButton: UIControl {
    public lazy var iconImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_arrow_bold_down")
        return imageView
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let showRightLine: Bool
    
    public init(showRightLine: Bool = true) {
        self.showRightLine = showRightLine
        super.init(frame: .zero)
        makeUI()
    }
    
    // 标记触摸开始的位置
    public var touchInside2 = false
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        isUserInteractionEnabled = true
        let stackView = UIStackView(arrangedSubviews: [titleLabel, iconImageView])
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        addSubview(stackView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 14),
            iconImageView.heightAnchor.constraint(equalToConstant: 14),
        ])
        
        guard showRightLine else {
            return
        }
        
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.71, green: 0.71, blue: 0.71, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        
        NSLayoutConstraint.activate([
            line.centerYAnchor.constraint(equalTo: centerYAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.widthAnchor.constraint(equalToConstant: 1),
            line.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchInside2 = true
        // 可选：高亮效果
        isHighlighted = true
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        // 检查手指是否仍在按钮范围内
        touchInside2 = bounds.contains(touch.location(in: self))
        isHighlighted = touchInside2 // 更新高亮状态
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
        // 如果手指在按钮内抬起，则触发事件
        if touchInside2 {
            sendActions(for: .touchUpInside)
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
        touchInside2 = false
    }
}
