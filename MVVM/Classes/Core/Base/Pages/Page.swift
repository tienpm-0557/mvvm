//
//  Page.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa
import Action
import PureLayout

extension Reactive where Base: IView {
    
    public typealias ViewModelElement = Base.ViewModelElement
    
    /**
     Custom binder for viewModel, can be any type
     
     This could be handy for binding a sub viewModel
     */
    public var viewModel: Binder<ViewModelElement?> {
        return Binder(base) { $0.viewModel = $1 }
    }
}

open class Page<VM: IViewModel>: UIViewController, IView, ITransitionView {
    
    public var disposeBag: DisposeBag? = DisposeBag()
    private var hudBag: DisposeBag? = DisposeBag()
    
    public var animatorDelegate: AnimatorDelegate?
    
    private var _viewModel: VM?
    public var viewModel: VM? {
        get { return _viewModel }
        set {
            if _viewModel != newValue {
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
    
    public private(set) var backButton: UIBarButtonItem?
    public private(set) var localHud: LocalHud? {
        didSet { bindLocalHud() }
    }
    
    private lazy var backAction: Action<Void, Void> = {
        return Action() { .just(self.onBack()) }
    }()
    
    public var enableBackButton: Bool = false {
        didSet {
            if enableBackButton {
                backButton = backButtonFactory().create()
                navigationItem.leftBarButtonItem = backButton
                backButton?.rx.bind(to: backAction, input: ())
            } else {
                navigationItem.leftBarButtonItem = nil
                backButton?.rx.unbindAction()
            }
        }
    }
    
    public let navigationService: INavigationService = DependencyManager.shared.getService()
    
    public init(viewModel: VM? = nil) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // setup default local hud
        let localHud = localHudFactory().create()
        view.addSubview(localHud)
        localHud.setupView()
        self.localHud = localHud
        
        initialize()
        viewModelChanged()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.rxViewState.accept(.willAppear)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.rxViewState.accept(.didAppear)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.rxViewState.accept(.willDisappear)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.rxViewState.accept(.didDisappear)
        
        if isMovingFromParent {
            destroy()
        }
    }
    
    /**
     Subclasses override this method to create its own hud loader.
     
     This method allows subclasses to create custom hud loader. To create the default hud loader, use global configurations `DDConfigurations.localHudFactory`
     */
    open func localHudFactory() -> Factory<LocalHud> {
        return DDConfigurations.localHudFactory
    }
    
    /**
     Subclasses override this method to create its own back button on navigation bar.
     
     This method allows subclasses to create custom back button. To create the default back button, use global configurations `DDConfigurations.backButtonFactory`
     */
    open func backButtonFactory() -> Factory<UIBarButtonItem> {
        return DDConfigurations.backButtonFactory
    }
    
    /**
     Subclasses override this method to initialize UIs.
     
     This method is called in `viewDidLoad`. So try not to use `viewModel` property if you are
     not sure about it
     */
    open func initialize() {}
    
    /**
     Subclasses override this method to create data binding between view and viewModel.
     
     This method always happens, so subclasses should check if viewModel is nil or not. For example:
     ```
     guard let viewModel = viewModel else { return }
     ```
     */
    open func bindViewAndViewModel() {}
    
    /**
     Subclasses override this method to do custom actions when hud loader view is toggle (hidden/shown).
     */
    open func localHudToggled(_ value: Bool) {}
    
    /**
     Subclasses override this method to remove all things related to `DisposeBag`.
     */
    open func destroy() {
        disposeBag = DisposeBag()
        hudBag = DisposeBag()
        viewModel?.destroy()
    }
    
    /**
     Subclasses override this method to create custom back action for back button.
     
     By default, this will call pop action in navigation or dismiss in modal
     */
    @objc open func onBack() {
        navigationService.pop()
    }
    
    private func bindLocalHud() {
        hudBag = DisposeBag()
        
        if let viewModel = viewModel, let localHud = localHud {
            let shared = viewModel.rxShowLocalHud.distinctUntilChanged()
            shared ~> localHud.rx.show => hudBag
            shared.subscribe(onNext: localHudToggled) => hudBag
        }
    }
    
    private func viewModelChanged() {
        bindLocalHud()
        bindViewAndViewModel()
        (_viewModel as? IReactable)?.reactIfNeeded()
    }
}






