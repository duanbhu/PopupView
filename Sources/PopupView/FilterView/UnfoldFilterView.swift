//
//  UnfoldFilterView.swift
//  PopupView
//
//  Created by Duanhu on 2025/6/10.
//

import UIKit

public protocol FilterParameterKeyable {
    /// 标题文本
    var title: String { get }
    
    /// 对应服务端api的参数
    var key: String { get }
    
    /// 选中的item对应的title
    var valueTitleKey: String { get }
    
    var tag: Int { get }
    
    init?(tag: Int)
    
    func bindType() -> FiltrateItemType.Type
}

public extension Dictionary<String, Any> {
    func valueTitle(for key: any FilterParameterKeyable) -> String {
        guard let name = self[key.valueTitleKey] as? String else { return key.title }
        if name.contains("全部") {
            return key.title
        }
        return name
    }
}

public extension Array<FiltrateSectionModel> {
    func reset(with parameters: [String: Any]?) {
        for sectionModel in self {
            guard let key = sectionModel.header.key, let id = parameters?[key.key] as? String else { continue }
            for item in sectionModel.items {
                item.isSelected = id == item.id
            }
            // 自定义时间时，需要传递开始时间、结束时间
//            if key == CherryKey.date_type.rawValue {
//                if let start_time = parameters?["start_time"] as? Int {
//                    sectionModel.header.startTime = start_time.toDate
//                }
//                
//                if let end_time = parameters?["end_time"] as? Int {
//                    sectionModel.header.endTime = end_time.toDate
//                }
//            }
        }
    }
    
    func reset() {
        for sectionModel in self {
            sectionModel.items.forEach { $0.isSelected = false }
        }
    }
    
    func toFilterParameters(_ filters: [String: Any] = [:]) -> [String: Any] {
        var parameters = filters
        for sectionModel in self {
            guard let key = sectionModel.header.key else { continue }
            let item = sectionModel.items.first { $0.isSelected }
            parameters[key.key] = item?.id
            parameters[key.valueTitleKey] = item?.config.title
            
            // 自定义时间时，需要传递开始时间、结束时间
            parameters["start_date"] = sectionModel.header.startTime
            parameters["end_date"] = sectionModel.header.endTime
        }
        return parameters
    }
}

public class UnfoldFilterView<T: FilterParameterKeyable>: UIView {
    public typealias ParameterKey = T
    
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
    
    let filterWidth: CGFloat
    
    let fixedSpace: CGFloat
    
    /// 已选择的参数
    var parameters: [String: Any] = [:] {
        didSet {
            updateItems()
        }
    }
    
    public init(frame: CGRect, filterWidth: CGFloat = 60, fixedSpace: CGFloat = 46) {
        self.filterWidth = filterWidth
        self.fixedSpace = fixedSpace
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
            filterButton.widthAnchor.constraint(equalToConstant: 60),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func makeUI(with keys: [ParameterKey]) {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        for key in keys {
            let button = UnfoldButton()
            button.titleLabel.text = key.title
            button.tag = key.tag
            stackView.addArrangedSubview(button)
            
            let w = key.title.singleLineWidth(font: button.titleLabel.font)
            button.widthAnchor.constraint(equalToConstant: w + fixedSpace).isActive = true
            button.addTarget(self, action: #selector(cherryItemAction), for: .touchUpInside)
        }
        stackView.addArrangedSubview(UIView())
    }
    
    // MARK: - action
    /// 筛选点击事件
    @objc func filterAction(_ sender: UIButton) {
        guard let viewController = viewController else { return }

        let alertController = FiltrateController(sectionModels: sectionModels, completion: nil)
        alertController.alert(at: viewController)
    }
    
    @objc func cherryItemAction(_ sender: UIButton) {
        guard let key = ParameterKey(tag: sender.tag),
              let sections = FiltrateConfiguration.default
            .buildSectionModel?(key, true)
        else { return }
        
        guard let viewController = viewController else { return }
        unfoldedContentView.show(sectionModels: sections, sender: self, at: viewController.view)
    }
    
    private func updateItems() {
        for view in stackView.arrangedSubviews {
            guard let button = view as? UnfoldButton, let key = ParameterKey(tag: button.tag) else { continue }
        
            let title = parameters.valueTitle(for: key)
            button.titleLabel.text = title
        }
    }
}

public extension UnfoldFilterView {
    @discardableResult
    func parameterKeys(_ keys: [ParameterKey]) -> Self {
        makeUI(with: keys)
        return self
    }
    
    @discardableResult
    func sectionModels(_ sectionModels: [FiltrateSectionModel]) -> Self {
        self.sectionModels = sectionModels
        return self
    }
    
    @discardableResult
    func viewController(_ viewController: UIViewController) -> Self {
        self.viewController = viewController
        return self
    }
}

