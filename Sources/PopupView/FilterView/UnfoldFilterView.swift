//
//  UnfoldFilterView.swift
//  PopupView
//
//  Created by Duanhu on 2025/6/10.
//

import UIKit

public protocol FilterParameterKeyable: Equatable {
    /// 标题文本
    var title: String { get }
    
    /// 对应服务端api的参数
    var key: String { get }
    
    /// 选中的item对应的title
    var valueTitleKey: String { get }
    
    var tag: Int { get }
    
    var isDateType: Bool { get }
    
    init?(tag: Int)
    
    func bindType() -> FiltrateItemType.Type
}

public extension FilterParameterKeyable {
    var isDateType: Bool { false }
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

public extension Notification.Name {
    nonisolated(unsafe) static var unfoldFilterCompleted = Notification.Name("PopupView_unfold_filter_completed")
}

public extension Array<FiltrateSectionModel> {
    /// 根据当前筛选条件，修改数据源
    /// - Parameter parameters: 已勾选参数
    func reset(with parameters: [String: Any]?) {
        for sectionModel in self {
            guard let key = sectionModel.header.key else { continue }
            let id = parameters?[key.key] as? String
            for item in sectionModel.items {
                item.isSelected = id == item.id
            }
            
            // 自定义时间时，需要传递开始时间、结束时间
            if let start_time = parameters?["start_date"] as? Date {
                sectionModel.header.startTime = start_time
            }
            
            if let end_time = parameters?["end_date"] as? Date {
                sectionModel.header.endTime = end_time
            }
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
    
    /// 根据勾选情况，修改筛选条件
    /// - Parameter parameters: 筛选条件
    func updateParameters(_ parameters: inout [String: Any]){
        for sectionModel in self {
            guard let key = sectionModel.header.key else { continue }
            let item = sectionModel.items.first { $0.isSelected }
            parameters[key.key] = item?.id
            parameters[key.valueTitleKey] = item?.config.title
            
            // 自定义时间时，需要传递开始时间、结束时间
            parameters["start_date"] = sectionModel.header.startTime
            parameters["end_date"] = sectionModel.header.endTime
        }
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
    
    /// 向下展开的视图
    private lazy var unfoldedContentView: UnfoldedContentView  = {
        let contentView = UnfoldedContentView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 104))
        contentView.collectionView.didSelectItemBlock = { [weak contentView, weak self] isCustomDateType in
            contentView?.hide()
            guard let self = self else { return }
            
            guard isCustomDateType else {
                // 点击item，更新筛选数据
                contentView?.collectionView.sections.updateParameters(&self.parameters)
                NotificationCenter.default.post(name: .unfoldFilterCompleted, object: self, userInfo: self.parameters)
                return
            }
            // 点击到了自定义时间， 弹出大弹窗
            self.updateSectionsForClickedCustomDate()
            self.filterAction(self.filterButton)
        }
        return contentView
    }()
    
    public var sectionModels: [FiltrateSectionModel] = []
    
    public weak var viewController: UIViewController?
    
    let filterWidth: CGFloat
    
    let fixedSpace: CGFloat
    
    /// 已选择的参数
    public var parameters: [String: Any] = [:] {
        didSet {
            updateItems()
        }
    }
    
    /// 重置时，设定的初始条件
    public var initialFilters: [String: Any] = [:]
    
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
        unfoldedContentView.hide()
        let alertController = FiltrateController(sectionModels: sectionModels, filters: parameters, initialFilters: initialFilters) { ret in
            // 点击确认后，更新
            ret.forEach { (key, value) in
                self.parameters.updateValue(value, forKey: key)
            }
            NotificationCenter.default.post(name: .unfoldFilterCompleted, object: self, userInfo: self.parameters)
        }
        alertController.alert(at: viewController)
    }
    
    @objc func cherryItemAction(_ sender: UIButton) {
        guard let viewController = viewController else { return }
        guard let key = ParameterKey(tag: sender.tag),
              let sections = FiltrateConfiguration.default
            .buildSectionModel?(key, true)
        else { return }
        
        sections.reset(with: parameters)
        
        // 点击到了自定义时间， 弹出大弹窗
        for section in sections {
            for item in section.items {
                if item.isSelected, FiltrateConfiguration.default.isNeedShowCustomDateFooterHandle?(section.header, item) == true {
                    updateSectionsForClickedCustomDate()
                    self.filterAction(self.filterButton)
                    return
                }
            }
        }

        unfoldedContentView.show(sectionModels: sections, sender: self, at: viewController.view)
    }
    
    private func updateItems() {
        for view in stackView.arrangedSubviews {
            guard let button = view as? UnfoldButton, let key = ParameterKey(tag: button.tag) else { continue }
        
            let title = parameters.valueTitle(for: key)
            button.titleLabel.text = title
        }
    }
    
    /// 更新大弹窗的数据源 —  弹出前已选中自定义时间
    func updateSectionsForClickedCustomDate() {
        for section in sectionModels {
            for item in section.items {
                if FiltrateConfiguration.default.isNeedShowCustomDateFooterHandle?(section.header, item) == true {
                    section.items.forEach { $0.isSelected = false }
                    item.isSelected = true
                    break
                }
            }
        }
        sectionModels.updateParameters(&parameters)
    }
    
    deinit {
        debugPrint("没有循环引用: \(self)")
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

