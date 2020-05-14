//
//  ViewModels.swift
//  MVVM
//

import Foundation
import RxSwift
import RxCocoa

protocol IReactable {
    var isReacted: Bool { get set }
    
    func reactIfNeeded()
    func react()
}

extension Reactive where Base: IGenericViewModel {
    
    public typealias ModelElement = Base.ModelElement
    
    public var model: Binder<ModelElement?> {
        return Binder(base) { $0.model = $1 }
    }
}


/// A master based ViewModel for all
open class ViewModel<M>: NSObject, IViewModel, IReactable {
    
    public typealias ModelElement = M
    
    private var _model: M?
    public var model: M? {
        get { return _model }
        set {
            _model = newValue
            modelChanged()
        }
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    public let rxViewState = BehaviorRelay<ViewState>(value: .none)
    public let rxShowLocalHud = BehaviorRelay(value: false)
    
    public let navigationService: INavigationService = DependencyManager.shared.getService()
    
    var isReacted = false
    
    required public init(model: M? = nil) {
        _model = model
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
    deinit {
        destroy()
    }
    
    /**
     Everytime model changed, this method will get called. Good place to update our viewModel
     */
    open func modelChanged() {}
    
    /**
     This method will be called once. Good place to initialize our viewModel (listen, subscribe...) to any signals
     */
    open func react() {}
    
    func reactIfNeeded() {
        guard !isReacted else { return }
        isReacted = true
        
        react()
    }
}

/**
 A based ViewModel for ListPage.
 
 The idea for ListViewModel is that it will contain a list of CellViewModels
 By using this list, ListPage will render the cell and assign ViewModel to it respectively
 */
open class ListViewModel<M, CVM: IGenericViewModel>: ViewModel<M>, IListViewModel {
    
    public typealias CellViewModelElement = CVM
    
    public typealias ItemsSourceType = [SectionList<CVM>]
    
    public let itemsSource = ReactiveCollection<CVM>()
    public let rxSelectedItem = BehaviorRelay<CVM?>(value: nil)
    public let rxSelectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    required public init(model: M? = nil) {
        super.init(model: model)
    }
    
    open override func destroy() {
        super.destroy()
        
        itemsSource.forEach { (_, sectionList) in
            sectionList.forEach({ (_, cvm) in
                cvm.destroy()
            })
        }
    }
    
    open func selectedItemDidChange(_ cellViewModel: CVM) { }
}

/**
 A based ViewModel for TableCell and CollectionCell
 
 The difference between ViewModel and CellViewModel is that CellViewModel does not contain NavigationService. Also CellViewModel
 contains its own index
 */

protocol IIndexable: class {
    var indexPath: IndexPath? { get set }
    var isLastRow: Bool { get set }
}

open class CellViewModel<M>: NSObject, IGenericViewModel, IIndexable, IReactable {
    
    public typealias ModelElement = M
    
    private var _model: M?
    public var model: M? {
        get { return _model }
        set {
            _model = newValue
            modelChanged()
        }
    }
    
    /// Each cell will keep its own index path
    /// In some cases, each cell needs to use this index to create some customizations
    public internal(set) var indexPath: IndexPath?
    public internal(set) var  isLastRow: Bool = false
    /// Bag for databindings
    public var disposeBag: DisposeBag? = DisposeBag()
    
    var isReacted = false
    
    public required init(model: M? = nil) {
        _model = model
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
    open func modelChanged() {}
    open func react() {}
    
    func reactIfNeeded() {
        guard !isReacted else { return }
        isReacted = true
        
        react()
    }
}

/// A usefull CellViewModel based class to support ListPage and CollectionPage that have more than one cell identifier
open class SuperCellViewModel: CellViewModel<Any> {
    
    required public init(model: Any? = nil) {
        super.init(model: model)
    }
}
