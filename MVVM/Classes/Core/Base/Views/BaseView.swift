//
//  BaseView.swift
//  Action
//
//  Created by pham.minh.tien on 5/3/20.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - Based UIView that support BasePage
open class BaseView: UIView, IView {
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    private var _viewModel: BaseViewModel?
    public var viewModel: BaseViewModel? {
        get { return _viewModel }
        set {
            if newValue != _viewModel {
                disposeBag = DisposeBag()
                
                _viewModel = newValue
                viewModelChanged()
            }
        }
    }
    
    public var anyViewModel: Any? {
        get { return _viewModel }
        set { viewModel = newValue as? BaseViewModel }
    }
    
    public init(viewModel: BaseViewModel? = nil) {
        self._viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    public init(frame: CGRect, viewModel: BaseViewModel? = nil) {
        self._viewModel = viewModel
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit { destroy() }
    
    func setup() {
        backgroundColor = .clear
        
        initialize()
        viewModelChanged()
    }
    
    private func viewModelChanged() {
        bindViewAndViewModel()
        _viewModel?.reactIfNeeded()
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }
    
    open func initialize() {}
    open func bindViewAndViewModel() {}
}

//MARK: Based Header TableView for list page
open class BaseHeaderTableView: UITableViewHeaderFooterView {
    
    open class var identifier: String {
        return String(describing: self)
    }
    
    open class var nib: UINib {
        return UINib(nibName:String(describing: self), bundle: Bundle.main)
    }
    
    open class var className: String {
        return NSStringFromClass(self.self)
    }
    
    open class func identifier(_ returnClassName: Bool = false) -> String {
        return (returnClassName ? NSStringFromClass(self.self) : String(describing: self))
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()

    private var _viewModel: BaseViewModel?
    public var viewModel: BaseViewModel? {
        get { return _viewModel }
        set {
            if newValue != _viewModel {
                disposeBag = DisposeBag()

                _viewModel = newValue
                viewModelChanged()
            }
        }
    }

    open class func height(withItem _item: BaseViewModel) -> CGFloat{
        return 30.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit { destroy() }

    private func setup() {
        self.backgroundView = UIView()
        initialize()
    }

    private func viewModelChanged() {
        bindViewAndViewModel()
        _viewModel?.reactIfNeeded()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        _viewModel = nil
    }

    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }

    open func initialize() {}
    open func bindViewAndViewModel() {}

    open class func getSize(withItem data: Any?) -> CGSize? {
        return nil
    }
}


//MARK: Based Header TableView for list page
open class BaseHeaderCollectionView: UICollectionReusableView {
    
    open class var identifier: String {
        return String(describing: self)
    }
    
    open class var nib: UINib {
        return UINib(nibName:String(describing: self), bundle: Bundle.main)
    }
    
    open class var className: String {
        return NSStringFromClass(self.self)
    }
    
    open class func identifier(_ returnClassName: Bool = false) -> String {
        return (returnClassName ? NSStringFromClass(self.self) : String(describing: self))
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()

    private var _viewModel: BaseViewModel?
    public var viewModel: BaseViewModel? {
        get { return _viewModel }
        set {
            if newValue != _viewModel {
                disposeBag = DisposeBag()

                _viewModel = newValue
                viewModelChanged()
            }
        }
    }

    open class func headerSize(withItem _item: BaseViewModel) -> CGSize{
        return CGSize(width: 30.0, height: 30.0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit { destroy() }

    private func setup() {
        initialize()
    }

    private func viewModelChanged() {
        bindViewAndViewModel()
        _viewModel?.reactIfNeeded()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        _viewModel = nil
    }

    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }

    open func initialize() {}
    open func bindViewAndViewModel() {}

    open class func getSize(withItem data: Any?) -> CGSize? {
        return nil
    }
}

//MARK: Based collection view cell for BaseCollectionPage
open class BaseCollectionCell: UICollectionViewCell, IView {
    
    open class var identifier: String {
        return String(describing: self)
    }
    
    open class var nib: UINib {
        return UINib(nibName:String(describing: self), bundle: Bundle.main)
    }
    
    open class var className: String {
        return NSStringFromClass(self.self)
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    private var _viewModel: BaseCellViewModel?
    public var viewModel: BaseCellViewModel? {
        get { return _viewModel }
        set {
            if newValue != _viewModel {
                disposeBag = DisposeBag()
                
                _viewModel = newValue
                viewModelChanged()
            }
        }
    }
    
    public var anyViewModel: Any? {
        get { return _viewModel }
        set { viewModel = newValue as? BaseCellViewModel }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit { destroy() }
    
    private func setup() {
        backgroundColor = .clear
        initialize()
    }
    
    private func viewModelChanged() {
        bindViewAndViewModel()
        _viewModel?.reactIfNeeded()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        _viewModel = nil
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }
    
    open func initialize() {}
    open func bindViewAndViewModel() {}
    
    open class func getSize(withItem data: Any?) -> CGSize? {
        return nil
    }
}

//MARK: Base table view cell for BaseListPage
open class BaseTableCell: UITableViewCell, IView {
    
    open class var identifier: String {
        return String(describing: self)
    }
    
    open class var nib: UINib {
        return UINib(nibName:String(describing: self), bundle: Bundle.main)
    }
    
    open class var className: String {
        return NSStringFromClass(self.self)
    }
    
    open class func identifier(_ returnClass: Bool = false) -> String {
        return (returnClass ? NSStringFromClass(self.self) : String(describing: self))
    }
    
    open class func height(withItem _item: BaseViewModel) -> CGFloat{
        return 30.0
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    private var _viewModel: BaseCellViewModel?
    public var viewModel: BaseCellViewModel? {
        get { return _viewModel }
        set {
            if newValue != _viewModel {
                disposeBag = DisposeBag()
                
                _viewModel = newValue
                viewModelChanged()
            }
        }
    }
    
    public var anyViewModel: Any? {
        get { return _viewModel }
        set { viewModel = newValue as? BaseCellViewModel }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit { destroy() }
    
    private func setup() {
        self.backgroundView = UIView()
        separatorInset = .zero
        layoutMargins = .zero
        preservesSuperviewLayoutMargins = false
        
        initialize()
    }
    
    private func viewModelChanged() {
        bindViewAndViewModel()
        _viewModel?.reactIfNeeded()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        _viewModel = nil
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }
    
    open func initialize() {}
    open func bindViewAndViewModel() {}
}

