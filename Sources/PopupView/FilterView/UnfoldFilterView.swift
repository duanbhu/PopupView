//
//  UnfoldFilterView.swift
//  PopupView
//
//  Created by Duanhu on 2025/6/10.
//

import UIKit
public protocol FilterParameterKeyable {
    var title: String { get }
    
    var tag: Int { get }
    
    init?(tag: Int)
}

public class UnfoldFilterView<T: FilterParameterKeyable>: UIView {
    public typealias FilterParameterKey = T
    
    /// 筛选按钮
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("筛选", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    lazy var stackView: UIStackView  = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fill
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var unfoldedContentView: UnfoldedContentView  = {
        let contentView = UnfoldedContentView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 104))
        contentView.collectionView.didSelectItemBlock = { [weak contentView] in
            contentView?.hide()
        }
        return contentView
    }()
    
    public var sectionModels: [FiltrateSectionModel] = []
    
    public weak var viewController: UIViewController?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        backgroundColor = .white
        [filterButton, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            filterButton.topAnchor.constraint(equalTo: topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            filterButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func makeUI(with keys: [FilterParameterKey]) {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        for key in keys {
            let button = UnfoldButton()
            button.titleLabel.text = key.title
            button.tag = key.tag
            stackView.addArrangedSubview(button)
            
            let w = key.title.singleLineWidth(font: button.titleLabel.font)
            button.widthAnchor.constraint(lessThanOrEqualToConstant: w + 46).isActive = true
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: w + 35).isActive = true
            button.addTarget(self, action: #selector(cherryItemAction), for: .touchUpInside)
        }
    }
    
    // MARK: - action
    /// 筛选点击事件
    @objc func filterAction(_ sender: UIButton) {
        guard let viewController = viewController else { return }

        let alertController = FiltrateController(sectionModels: sectionModels, completion: nil)
        alertController.alert(at: viewController)
    }
    
    @objc func cherryItemAction(_ sender: UIButton) {
        guard let key = FilterParameterKey(tag: sender.tag),
              let section = FiltrateConfiguration.default
            .buildSectionModel?(key, true)
        else { return }
        let sectionModels: [FiltrateSectionModel] = [section]
        
        guard let viewController = viewController else { return }
        unfoldedContentView.show(sectionModels: sectionModels, sender: self, at: viewController.view)
    }
    
    @discardableResult
    public func parameterKeys(_ keys: [FilterParameterKey]) -> Self {
        makeUI(with: keys)
        return self
    }
}
