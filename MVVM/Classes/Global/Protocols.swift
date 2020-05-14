//
//  Protocols.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa

/// Destroyable type for handling dispose bag and destroy it
public protocol IDestroyable: class {
    
    var disposeBag: DisposeBag? { get set }
    func destroy()
}

/// PopView type for Page to implement as a pop view
public protocol IPopupView: class {
    
    /*
     Setup popup layout
     
     Popview is a UIViewController base, therefore it already has a filled view in. This method allows
     implementation to layout it customly. For example:
     
     ```
     view.cornerRadius = 7
     view.autoCenterInSuperview()
     ```
     */
    func popupLayout()
    
    /*
     Show animation
     
     The presenter page has overlayView, use this if we want to animation the overlayView too, e.g alpha
     */
    func show(overlayView: UIView)
    
    /*
     Hide animation
     
     Must call completion when the animation is finished
     */
    func hide(overlayView: UIView, completion: @escaping (() -> ()))
}

/// TransitionView type to create custom transitioning between pages
public protocol ITransitionView: class {
    
    /**
     Keep track of animator delegate for custom transitioning
     */
    var animatorDelegate: AnimatorDelegate? { get set }
}

/// AnyView type for helping assign any viewModel to any view
public protocol IAnyView: class {
    
    /**
     Any value assign to this property will be delegate to its correct viewModel type
     */
    var anyViewModel: Any? { get set }
}

/// Base View type for the whole library
public protocol IView: IAnyView, IDestroyable {
    
    associatedtype ViewModelElement
    
    var viewModel: ViewModelElement? { get set }
    
    func initialize()
    func bindViewAndViewModel()
}

// MARK: - Viewmodel protocols

/// Base generic viewModel type, implement Destroyable and Equatable
public protocol IGenericViewModel: IDestroyable, Equatable {
    
    associatedtype ModelElement
    
    var model: ModelElement? { get set }
    
    init(model: ModelElement?)
}

/// Base ViewModel type for Page (UIViewController), View (UIVIew)
public protocol IViewModel: IGenericViewModel {
    var rxViewState: BehaviorRelay<ViewState> { get }
    var rxShowLocalHud: BehaviorRelay<Bool> { get }
    
    var navigationService: INavigationService { get }
}

public protocol IListViewModel: IViewModel {
    
    associatedtype CellViewModelElement: IGenericViewModel
    
    var itemsSource: ReactiveCollection<CellViewModelElement> { get }
    var rxSelectedItem: BehaviorRelay<CellViewModelElement?> { get }
    var rxSelectedIndex: BehaviorRelay<IndexPath?> { get }
    
    func selectedItemDidChange(_ cellViewModel: CellViewModelElement)
}


















