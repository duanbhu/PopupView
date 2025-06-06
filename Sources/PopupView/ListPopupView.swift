//
//  ListPickerView.swift
//  PopupView_Example
//
//  Created by Duanhu on 2025/6/5.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

open class ListPopupView<CellType: UITableViewCell, T: Any>: PopupView, UITableViewDataSource, UITableViewDelegate {
    
    public typealias ItemType = T
    
    var tableView: UITableView = UITableView()
    
    let items: [T]
    
    var configCellHandle: ((Int, CellType, ItemType) -> ())?
    
    var itemSelectHandle: ((Int, ItemType) -> ())?
    
    public init(items: [T]) {
        self.items = items
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
        tableView.register(CellType.self, forCellReuseIdentifier: "cellId")
        
        let cellNib = UINib(nibName: "\(CellType.self)", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cellId")        
        contentStackView.addArrangedSubview(tableView)
        tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        tableView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
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
}
