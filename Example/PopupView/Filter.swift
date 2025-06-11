//
//  Filter.swift
//  PopupView_Example
//
//  Created by Duanhu on 2025/6/11.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import PopupView

enum FilterParameterKey: Int, FilterParameterKeyable {
    case date_type = 0 // 查询日期
    case order_type // 订单类型
    case order_status // 订单状态
    case order_source // 订单来源
    
    var title: String {
        switch self {
        case .date_type: "时间"
        case .order_type: "订单类型"
        case .order_status: "订单状态"
        case .order_source: "订单来源"
        }
    }
    
    var tag: Int {
        return 1000010 + rawValue
    }
    
    init?(tag: Int) {
        self.init(rawValue: tag - 1000010)
    }
    
    var key: String { return "\(self)" }
    
    var valueTitleKey: String { "\(self)_value_title"}
    
    func bindType() -> FiltrateItemType.Type {
        switch self {
        case .date_type:
            return DateType.self
        case .order_type:
            return OrderType.self
        case .order_status:
            return OrderStatus.self
        case .order_source:
            return OrderSource.self
        }
    }
}

public enum DateType: Int {
    
    case all = 0
    
    case custom // 1、自定义时间。此时需要传递start_time、end_time
    
    case today // 2、今天
    
    case yesterday // 3、昨天
    
    case dayBeforeYesterday // 4、前天
    
    case within3Days // 5、3天内（前天 + 昨天 + 今天）
    
    case within1Week // 6、1周内（过去6天 + 今天）
    
    case within15Days // 7、15天内（过去14天 + 今天）
    
    case within1Month// 8、1个月内（过去29天 + 今天）
    
    case thisMonth // 9、这个月1号到现在
    
    case lastMonth // 10、上月（上个月1号到上个月最后1天）
    
    case within2Months// 11、2个月内（上个月 + 这个月1号到现在）
    
    case within3Months// 12、3个月内（过去2个月 + 这个月1号到现在）
    
    case half1Year // 13、半年内（过去5个月 + 这个月1号到现在）
}

extension DateType: FiltrateItemType {
    public var id: String? {
        return "\(rawValue)"
    }
    
    public var title: String? {
        switch self {
        case .all: "全部"
        case .custom:
            "自定义"
        case .today:
            "今天"
        case .yesterday:
            "昨天"
        case .dayBeforeYesterday:
            "前天"
        case .within3Days:
            "3天内"
        case .within1Week:
            "一周内"
        case .within15Days:
            "15天内"
        case .within1Month:
            "一个月内"
        case .thisMonth:
            "本月"
        case .lastMonth:
            "上月"
        case .within2Months:
            "2个月内"
        case .within3Months:
            "3个月内"
        case .half1Year:
            "半年内"
        }
    }
    
    public static func items(for alias: String?) -> [DateType] {
        return [.today, .yesterday, .within1Week, .within1Month, .thisMonth, .custom]
    }
}

public enum OrderType: Int, FiltrateItemType {
    case all = 0, timely, prebook
    
    public var id: String? { return "\(rawValue)"}
    
    public var title: String? {
        switch self {
        case .all:
            "全部"
        case .timely:
            "及时单"
        case .prebook:
            "预约单"
        }
    }
    
    public static func items(for alias: String?) -> [OrderType] {
        return [.all, .timely, .prebook]
    }
}

public enum OrderStatus: Int, FiltrateItemType {
    case all = 0, completed, ignore, returnMeal, timeout
    public var id: String? { return "\(rawValue)"}
    
    public var title: String? {
        switch self {
        case .all:
            "全部"
        case .completed:
            "已完成"
        case .ignore:
            "忽略配送"
        case .returnMeal:
            "退餐"
        case .timeout:
            "配送超时"
        }
    }
    
    public static func items(for alias: String?) -> [OrderStatus] {
        return [.all, .completed, .ignore, .returnMeal, .timeout]
    }
}

public enum OrderSource: Int, FiltrateItemType {
    public var id: String? { "\(self.rawValue)" }
    
    public var title: String? {
        switch self {
        case .all: "全部"
        case .meituan: "美团"
        case .jd: "京东秒送"
        case .douyin: "抖音外卖"
        }
    }
    
    public static func items(for alias: String?) -> [OrderSource] {
        return [.all, .meituan, .jd, .douyin]
    }
    
    case all = 0, meituan, jd, douyin
}

