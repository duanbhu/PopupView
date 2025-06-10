//
//  NextViewController.swift
//  PopupView_Example
//
//  Created by Duanhu on 2025/6/10.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import PopupView

enum FilterParameterKey: Int, FilterParameterKeyable {
    case date_type = 0 // 查询日期
    case order_type // 订单类型
    case order_status // 订单状态
    
    var title: String {
        switch self {
        case .date_type: "时间"
        case .order_type:
            "订单类型"
        case .order_status:
            "订单状态"
        }
    }
    
    var tag: Int {
        return 1000010 + rawValue
    }
    
    init?(tag: Int) {
        self.init(rawValue: tag - 1000010)
    }
}

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)

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
        
        let filterView = UnfoldFilterView<FilterParameterKey>(frame: CGRect(x: 16, y: 100, width: view.frame.width - 32, height: 46));
        filterView.parameterKeys([.date_type, .order_type, .order_status])
        filterView.viewController = self
        filterView.sectionModels = sectionModels
        view.addSubview(filterView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
