//
//  FilterCollectionViewCell.swift
//  MobileExt
//
//  Created by Duanhu on 2024/4/17.
//

import UIKit

open class FiltrateCell: UICollectionViewCell {
    public private(set) lazy var titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        contentView.addSubview(button)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleButton.frame = self.bounds
        
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleButton.topAnchor.constraint(equalTo: topAnchor),
            titleButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(to item: FiltrateItemViewModel) {
        titleButton.isSelected = item.isSelected
        if item.isSelected {
            titleButton.update(with: item.selectConfig, state:.selected)
        } else {
            titleButton.update(with: item.config, state: .normal)
        }
    }
}
