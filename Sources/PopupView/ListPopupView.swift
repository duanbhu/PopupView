//
//  ListPickerView.swift
//  PopupView_Example
//
//  Created by Duanhu on 2025/6/5.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

open class ListPopupView<CellType: UITableViewCell, T: Any>: BasePopupView, ButtonStackable, UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate {
    
    public typealias ItemType = T
    
    public var tableView: UITableView = UITableView()
    
    public var items: [T]
    
    public let nibName: String?
    
    public var configCellHandle: ((Int, CellType, ItemType) -> ())?
    
    public var itemSelectHandle: ((Int, ItemType) -> ())?
    
    private var tableViewMinHeight: NSLayoutConstraint?
    
    public init(items: [T], nibName: String? = nil) {
        self.items = items
        self.nibName = nibName
        super.init(backgroundInsets: .zero, contentViewInsets: .zero)
    }
    
    @MainActor required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func makeUI() {
        super.makeUI()
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.delegate = self
        tableView.dataSource = self
        
        if let nibName = nibName {
            let cellNib = UINib(nibName: nibName, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "cellId")
        } else {
            tableView.register(CellType.self, forCellReuseIdentifier: "cellId")
        }
        contentStackView.addArrangedSubview(tableView)
        
        tableViewMinHeight = tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            tableView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.7),
            tableViewMinHeight!
        ])
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! CellType
        configCellHandle?(indexPath.row, cell, items[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDataDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelectHandle?(indexPath.row, items[indexPath.row])
    }
    
    // MARK: - UITableViewDragDelegate
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = items[indexPath.row]
        return [dragItem]
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = items.remove(at: sourceIndexPath.row)
        items.insert(mover, at: destinationIndexPath.row)
    }
}

public extension ListPopupView {
    @discardableResult
    func configCellHandle(_ configCellHandle: ((Int, CellType, ItemType) -> ())?) -> Self {
        self.configCellHandle = configCellHandle
        return self
    }
    
    @discardableResult
    func itemSelectHandle(_ handle: ((Int, ItemType) -> ())?) -> Self {
        self.itemSelectHandle = handle
        return self
    }
    
    @discardableResult
    func rowHeight(_ rowHeight: CGFloat) -> Self {
        tableView.rowHeight = rowHeight
        return self
    }
    
    /// list 最低高度， 默认200
    @discardableResult
    func minimumHeight(_ minimumHeight: CGFloat) -> Self {
        tableViewMinHeight?.constant = minimumHeight
        return self
    }
    
    /// 开启拖拽功能
    func dragInteractionEnabled(_ enabled: Bool) -> Self {
        tableView.dragInteractionEnabled = enabled
        tableView.dragDelegate = self
        return self
    }
}
