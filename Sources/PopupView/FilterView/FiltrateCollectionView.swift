//
//  FiltrateCollectionView.swift
//  MobileExt
//
//  Created by Duanhu on 2024/4/23.
//

import UIKit

private extension String {
    static let headerId = "FiltrateHeaderView"
    static let cellId = "cellId"
    static let dateFooterId = "FiltrateDateFooterView"
    static let lineFooterId = "FiltrateLineFooterView"
}

open class FiltrateCollectionView: UICollectionView {
    var sections: [FiltrateSectionModel] = [] {
        didSet {
            self.reloadData()
        }
    }
        
    open var didSelectItemBlock: (() -> ())?
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    init(frame: CGRect) {
        let flowLayout = AlignedCollectionViewFlowLayout()
        flowLayout.horizontalAlignment = .leading
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        super.init(frame: frame, collectionViewLayout: flowLayout)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .white
        
        register(FiltrateCell.self, forCellWithReuseIdentifier: .cellId)
        register(FiltrateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: .headerId)
        register(FiltrateDateFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: .dateFooterId)
        
        register(FiltrateDateFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: .dateFooterId)
        register(FiltrateLineFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: .lineFooterId)
        
        collectionViewHeightConstraint = self.heightAnchor.constraint(greaterThanOrEqualToConstant: frame.height)
        heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.7).isActive = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHeight() {
        let height = self.collectionViewLayout.collectionViewContentSize.height
        guard height != self.frame.height else { return }
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
        collectionViewHeightConstraint.constant = height
    }
}

extension FiltrateCollectionView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .cellId, for: indexPath) as! FiltrateCell
        let item = sections[indexPath.section].items[indexPath.item]
        cell.bind(to: item)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let model = sections[indexPath.section].header
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: .headerId, for: indexPath) as! FiltrateHeaderView
            header.bind(to: model)
            return header
        default:
            guard isNeedShowCustomDateFooter(for: indexPath.section) else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: .lineFooterId, for: indexPath)
            }
         let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: .dateFooterId, for: indexPath) as! FiltrateDateFooterView
            return footer
        }
    }
    
    func isNeedShowCustomDateFooter(for section: Int) -> Bool {
        let headerViewModel = sections[section].header
        let selectItem = sections[section].items.first(where: { $0.isSelected })
        return FiltrateConfiguration.default.isNeedShowCustomDateFooterHandle?(headerViewModel, selectItem) ?? false
    }
}

extension FiltrateCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        if section.header.allowMultiSelect {
            // 允许多选
            let item = section.items[indexPath.item]
            item.isSelected = !item.isSelected
            if item.isSelected, item.isRepelWhenMultiSelect {
                section.items.filter { $0 != item }.forEach { $0.isSelected = false }
            } else if item.isSelected, !item.isRepelWhenMultiSelect {
                section.items.filter { $0.isSelected && $0 != item && $0.isRepelWhenMultiSelect }
                    .forEach { $0.isSelected = false }
            }
        } else {
            // 单选
            for (idx, item) in section.items.enumerated() {
                item.isSelected = idx == indexPath.item
            }
        }
        collectionView.reloadData()
        didSelectItemBlock?()
        updateHeight()
    }
}

extension FiltrateCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = sections[indexPath.section].items[indexPath.item]
        return CGSize(width: item.authWidth(), height: item.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: sections[section].header.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard isNeedShowCustomDateFooter(for: section) else {
            return CGSize(width: self.frame.width, height: 14)
        }
        return CGSize(width: self.frame.width, height: 100)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].header.sectionInset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].header.lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].header.itemSpacing
    }
}
