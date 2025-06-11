//
//  FiltrateController.swift
//  PopupView_Example
//
//  Created by Duanhu on 2025/6/7.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

public typealias FiltrateCompletionBlock = ([String: Any]) -> ()

public class FiltrateController: UIViewController {
    lazy var collectionView: FiltrateCollectionView = {
        let view = FiltrateCollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width - 32, height: 0))
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.5
        return view
    }()

    let sectionModels: [FiltrateSectionModel]
    
    let completion: FiltrateCompletionBlock?
    
    /// 已选中的筛选条件
    let filters: [String: Any]
    
    /// 初始筛选条件:   重置后，恢复到初始筛选条件
    let initialFilters: [String: Any]
    
    /// 圆角
    let cornerRadius: CGFloat = 12
    
    // MARK: - NSLayoutConstraint
            
    public init(sectionModels: [FiltrateSectionModel], filters: [String: Any] = [:], initialFilters: [String: Any] = [:], completion: FiltrateCompletionBlock?) {
        self.sectionModels = sectionModels
        self.completion = completion
        self.filters = filters
        self.initialFilters = initialFilters
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        
        collectionView.sections = sectionModels
        collectionView.updateHeight()
    }
    
    func makeUI() {
        view.addSubview(backgroundView)
        view.addSubview(contentView)
        
        let resetButton = UIButton(type: .custom)
        resetButton.setTitle("重置", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.backgroundColor = .white
        resetButton.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        
        let confirmButton = UIButton(type: .custom)
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .orange
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
         
        let stackView = UIStackView(arrangedSubviews:[resetButton, confirmButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        contentView.addSubview(collectionView)
        contentView.addSubview(stackView)
        
        stackView.layer.cornerRadius = cornerRadius
        stackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        stackView.clipsToBounds = true
        
        [backgroundView, stackView, contentView, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.collectionViewHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 58),
            stackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
        
        // 居中显示
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    /// 重置
    @objc func resetAction() {
        sectionModels.reset(with: initialFilters)
        collectionView.reloadData()
    }
    
    /// 确认
    @objc func confirmAction() {
        let parameters = sectionModels.toFilterParameters(filters)
        
        completion?(parameters)
        dismiss(animated: false)
    }
    
    public func alert(at viewController: UIViewController) {
        self.modalPresentationStyle = .fullScreen
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overCurrentContext;
        viewController.present(self, animated: false, completion: nil)
    }
}
