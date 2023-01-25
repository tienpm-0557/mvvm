//
//  Views.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa

/// Based UIView that support ViewModel
open class View<VM: IGenericViewModel>: UIView, IView {
    public typealias ViewModelElement = VM
    public var disposeBag: DisposeBag? = DisposeBag()
    private var _viewModel: VM?
    public var viewModel: VM? {
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
        set { viewModel = newValue as? VM }
    }

    public init(viewModel: VM? = nil) {
        self._viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    public init(frame: CGRect, viewModel: VM? = nil) {
        self._viewModel = viewModel
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        initialize()
        viewModelChanged()
    }

    open func initialize() {}
    open func bindViewAndViewModel() {}

    private func viewModelChanged() {
        bindViewAndViewModel()
        (_viewModel as? IReactable)?.reactIfNeeded()
    }

    deinit { destroy() }

    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }
}

/// Master based cell for CollectionPage
open class CollectionCell<VM: IGenericViewModel>: UICollectionViewCell, IView {
    open class var identifier: String {
        return String(describing: self)
    }
    public typealias ViewModelElement = VM
    public var disposeBag: DisposeBag? = DisposeBag()
    private var _viewModel: VM?
    public var viewModel: VM? {
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
        set { viewModel = newValue as? VM }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        initialize()
    }

    private func viewModelChanged() {
        bindViewAndViewModel()
        (_viewModel as? IReactable)?.reactIfNeeded()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        _viewModel = nil
    }

    open func initialize() {}
    open func bindViewAndViewModel() {}
    deinit { destroy() }
    open func destroy() {
        disposeBag = DisposeBag()
        viewModel?.destroy()
    }
}

/// Master cell for ListPage
open class TableCell<VM: IGenericViewModel>: UITableViewCell, IView {
    open class var identifier: String {
        return String(describing: self)
    }

    public typealias ViewModelElement = VM
    public var disposeBag: DisposeBag? = DisposeBag()
    private var _viewModel: VM?
    public var viewModel: VM? {
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
        set { viewModel = newValue as? VM }
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
        separatorInset = .zero
        layoutMargins = .zero
        preservesSuperviewLayoutMargins = false
        initialize()
    }

    private func viewModelChanged() {
        bindViewAndViewModel()
        (_viewModel as? IReactable)?.reactIfNeeded()
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
