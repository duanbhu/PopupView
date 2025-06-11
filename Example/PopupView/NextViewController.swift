//
//  NextViewController.swift
//  PopupView_Example
//
//  Created by Duanhu on 2025/6/10.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import PopupView

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)

        let keys: [FilterParameterKey] = [.date_type, .order_type, .order_source]
        let sectionModels = keys.map {
            FiltrateSectionModel.init(key: $0, items: $0.bindType().items(for: nil))
        }
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
