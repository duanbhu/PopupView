//
//  ViewController.swift
//  PopupView
//
//  Created by duanbhu on 05/27/2025.
//  Copyright (c) 2025 duanbhu. All rights reserved.
//

import UIKit
import PopupView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let config = PopupConfiguration.default()
        config.bodyInsets = UIEdgeInsets(top: 24, left: 16, bottom: 44, right: 16)
        config.titleConfiguration.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.91, alpha: 1)
        config.titleConfiguration.titleColor = UIColor(red: 0.36, green: 0.3, blue: 0.45, alpha: 1)
        config.titleConfiguration.font = UIFont(name: "苹方-简 中粗体", size: 16) ?? .boldSystemFont(ofSize: 16)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tap(_ sender: Any) {
        PopupView()
            .title("温馨提示")
            .message("确认要删除该发货门店吗？")
            .addAction(.title("再想想"), .backgroundColor(.gray))
            .addAction(.title("确认删除"), .backgroundColor(.blue))
            .alert()
    }
    
    @IBAction func tap2(_ sender: Any) {
        StringPickerView(items: ["5分钟", "10分钟", "15分钟", "20分钟", "25分钟", "30分钟"])
            .defaultItem("20分钟")
            .title("选择时间")
            .completion({ item in
                debugPrint("选择： \(item)")
            })
            .actionSheet()
        
//        DatePickerView()
//            .title("选择时间")
//            .datePickerMode(.date)
//            .completion({ item in
//                debugPrint("选择： \(item)")
//            })
//            .actionSheet()
    }
}

