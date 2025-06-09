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
    
    let dataList = ["alert message", "string picker", "date picker", "list popup", "filter alert"]

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
            if header.key == "dateType", item?.id == "custom" {
                return true
            }
            return false
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
            ListPopupView<ListTableViewCell, String>(items: items)
                .title("选择列表")
                .configCellHandle({ row, cell, item in
                    cell.titleLabel.text = item
                })
                .addAction("我知道了", config: .cancel)
                .addAction(config: .confirm, handel: { popupView in
                    
                })
                .actionSheet()
        case 4:
            
            let sectionModels: [FiltrateSectionModel] = [
                FiltrateSectionModel(
                    header: .init(title: "选择时间：") .key("dateType"),
                    items: [
                        FiltrateItemViewModel(title: "今日"),
                        FiltrateItemViewModel(title: "昨天"),
                        FiltrateItemViewModel(title: "一周内"),
                        FiltrateItemViewModel(title: "一月内"),
                        FiltrateItemViewModel(title: "本月"),
                        FiltrateItemViewModel(title: "自定义").id("custom"),
                    ]),
                FiltrateSectionModel(
                    header: .init(title: "订单类型："),
                    items: [
                        FiltrateItemViewModel(title: "全部"),
                        FiltrateItemViewModel(title: "及时单"),
                        FiltrateItemViewModel(title: "预约单"),
                    ]),
                FiltrateSectionModel(
                    header: .init(title: "订单状态："),
                    items: [
                        FiltrateItemViewModel(title: "全部"),
                        FiltrateItemViewModel(title: "已完成"),
                        FiltrateItemViewModel(title: "忽略配送"),
                        FiltrateItemViewModel(title: "退餐"),
                        FiltrateItemViewModel(title: "配送超时"),
                    ]),
                FiltrateSectionModel(
                    header: .init(title: "订单来源："),
                    items: [
                        FiltrateItemViewModel(title: "全部"),
                        FiltrateItemViewModel(title: "美团"),
                        FiltrateItemViewModel(title: "京东秒送"),
                        FiltrateItemViewModel(title: "抖音外卖")
                    ]),
                FiltrateSectionModel(
                    header: .init(title: "标题五:"),
                    items: [
                        FiltrateItemViewModel(title: "全部"),
                        FiltrateItemViewModel(title: "及时单"),
                        FiltrateItemViewModel(title: "预约单"),
                    ])
            ]
            
            let alertController = FiltrateController(sectionModels: sectionModels, completion: nil)
            alertController.alert(at: self)
            break
        default: break
            
        }
    }
}

extension FiltrateItemViewModel {
    convenience init(title: String) {
        self.init()
        self.config.update(part: .title(title))
        self.selectConfig.update(part: .title(title))
        self.width = 73
    }
}

extension FiltrateHeaderItemViewModel {
    convenience init(title: String) {
        self.init()
        self.height(55)
            .itemSpacing(8)
            .lineSpacing(8)
        self.config.update(part: .title(title))
    }
}
