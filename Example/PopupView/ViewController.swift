//
//  ViewController.swift
//  PopupView
//
//  Created by duanbhu on 05/27/2025.
//  Copyright (c) 2025 duanbhu. All rights reserved.
//

import UIKit
import PopupView

class ViewController: UITableViewController {
    
    let dataList = ["alert message", "string picker", "date picker", "list popup", "filter alert", "next"]

    private lazy var filters: [String: Any] = {
        var filters: [String: Any] = [:]
        filters[FilterParameterKey.date_type.key] = DateType.today.id
        filters[FilterParameterKey.order_type.key] = OrderType.all.id
        filters[FilterParameterKey.order_source.key] = OrderSource.all.id
        return filters
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let config = PopupConfiguration.default()
        config.bodyInsets = UIEdgeInsets(top: 24, left: 16, bottom: 44, right: 16)
        config.titleConfiguration.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.91, alpha: 1)
        config.titleConfiguration.titleColor = UIColor(red: 0.36, green: 0.3, blue: 0.45, alpha: 1)
        config.titleConfiguration.font = UIFont(name: "苹方-简 中粗体", size: 16) ?? .boldSystemFont(ofSize: 16)
        
        config.cancelConfiguration = LabelButtonConfig(
            .backgroundColor(UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)),
            .font(.systemFont(ofSize: 16)),
            .title("取消"),
            .titleColor(.black)
        )
        
        config.confirmConfiguration = LabelButtonConfig(
            .backgroundColor(.orange),
            .font(.systemFont(ofSize: 16)),
            .title("确认"),
            .titleColor(.white)
        )
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        FiltrateConfiguration.default.isNeedShowCustomDateFooterHandle = { header, item in
            guard let key = header.key as? FilterParameterKey else { return false }
            if key == .date_type, item?.id == "\(DateType.custom.rawValue)" {
                return true
            }
            return false
        }
        
        FiltrateConfiguration.default
            .buildSectionModel = { key, isUnfold in
                guard let key = key as? FilterParameterKey else { return [] }
                return [
                    .init(key: key, isUnfold: isUnfold, items: key.bindType().items(for: nil))
                ]
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = dataList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            PopupView()
                .title("温馨提示")
                .message("确认要删除该发货门店吗？")
                .addAction("我知道了", config: .cancel)
                .addAction("确认删除", config: .confirm, handel: { popupView in
                    
                })
                .alert()
        case 1:
            StringPickerView(items: ["5分钟", "10分钟", "15分钟", "20分钟", "25分钟", "30分钟"])
                .defaultItem("20分钟")
                .title("选择时间")
                .completion({ item in
                    debugPrint("选择： \(item)")
                })
                .actionSheet()
        case 2:
            DatePickerView()
                .title("选择时间")
                .datePickerMode(.date)
                .completion({ item in
                    debugPrint("选择： \(item)")
                })
                .actionSheet()
        case 3:
            let items = (0...10).map { "item_\($0) " }
            ListPopupView<ListTableViewCell, String>(items: items, nibName: "ListTableViewCell")
                .title("选择列表")
                .configCellHandle({ row, cell, item in
                    cell.titleLabel.text = item
                })
                .addAction("我知道了", config: .cancel)
                .addAction(config: .confirm, handel: { popupView in
                    popupView.hide()
                })
                .actionSheet()
        case 4:
            let keys: [FilterParameterKey] = [.date_type, .order_type, .order_source]
            let sectionModels = keys.map {
                FiltrateSectionModel.init(key: $0)
            }
            
            sectionModels.reset(with: filters)
            var filters: [String: Any] = [:]
            filters[FilterParameterKey.date_type.key] = DateType.today.id
            filters[FilterParameterKey.order_type.key] = OrderType.all.id
            filters[FilterParameterKey.order_source.key] = OrderSource.all.id
            let initialFilters: [String: Any] = filters
            let alertController = FiltrateController(sectionModels: sectionModels, initialFilters: initialFilters) { filters in
                self.filters = filters
            }
            alertController.alert(at: self)
        case 5:
            let nextVC = NextViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        default: break
            
        }
    }
}

extension FiltrateItemViewModel {
    convenience init(item: FiltrateItemType, isUnfold: Bool = false) {
        self.init(item: item)
        self.selectConfig = .init(
            .title(item.title),
            .backgroundColor(.orange),
            .titleColor(.white)
        )
        if isUnfold {
            self.width = 86
            self.config = .init(
                .title(item.title),
                .backgroundColor(.white),
                .titleColor(.black),
                .borderColor(.orange),
                .cornerRadius(4)
            )
        } else {
            self.width = 73
            self.config = .init(
                .title(item.title),
                .backgroundColor(.init(white: 0.95, alpha: 1)),
                .titleColor(.black)
            )
        }
    }
}

extension FiltrateHeaderItemViewModel {
    convenience init(key: FilterParameterKey, isUnfold: Bool = false, alias: String? = nil) {
        self.init()
        if isUnfold {
            self.itemSpacing(16)
                .lineSpacing(16)
        } else {
            self.height(55)
                .itemSpacing(8)
                .lineSpacing(8)
        }
        self.key(key)
        self.alias = alias
        self.config.update(part: .title(key.title))
    }
}

extension FiltrateSectionModel {
    init(key: FilterParameterKey, isUnfold: Bool = false, alias: String? = nil, items: [FiltrateItemType]) {
        self.init(
            header: FiltrateHeaderItemViewModel(key: key, isUnfold: isUnfold, alias: alias),
            items: items.map { FiltrateItemViewModel(item: $0, isUnfold: isUnfold) }
        )
    }
    
    init(key: FilterParameterKey, isUnfold: Bool = false, alias: String? = nil) {
        let items = key.bindType().items(for: alias)
        self.init(
            header: FiltrateHeaderItemViewModel(key: key, isUnfold: isUnfold, alias: alias),
            items: items.map { FiltrateItemViewModel(item: $0, isUnfold: isUnfold) }
        )
    }
}
