//
//  BasePage.swift
//  MVVM
//

import Foundation
import RxSwift
import RxCocoa
import Action
import PureLayout

open class BasePage: UIViewController, ITransitionView {
    public var disposeBag: DisposeBag? = DisposeBag()
    private var activityBag: DisposeBag? = DisposeBag()
    
    public var animatorDelegate: AnimatorDelegate?
    
    public private(set) var backButton: UIBarButtonItem?
    
    public lazy var backAction: Action<AnyObject, Void> = {
        return Action() { sender in
            .just(self.onBack(sender))
        }
    }()
    
    public var enableBackButton: Bool = false {
        didSet {
            if enableBackButton {
                backButton = backButtonFactory().create()
                navigationItem.leftBarButtonItem = backButton
                backButton?.rx.bind(to: backAction, input: (backButton!))
            } else {
                navigationItem.leftBarButtonItem = nil
                backButton?.rx.unbindAction()
            }
        }
    }
    //
    public private(set) var activityIndicatorHub: LocalHud? {
        didSet {
            bindLocalHud()
        }
    }
    
    public let navigationService: NavigationService = DependencyManager.shared.getService()
    public let storageService: IStorageService = DependencyManager.shared.getService()
    public let alertService: IAlertService = DependencyManager.shared.getService()
    public let localeService: LocalizeService = DependencyManager.shared.getService()
    
    deinit {
        destroy()
    }
    
    public private(set) var viewModel: BaseViewModel?
    
    public convenience init(viewModel vm: BaseViewModel) {
        self.init()
        self.viewModel = vm
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        registerService()
        initialize()
        updateAfterViewModelChanged()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            destroy()
        }
    }
    
    open func setupActivityIndicatorView(withMessage message: String? = "Loading") {
        // setup default local hud
        let acitvityIndicatorHud = activityIndicatorFactory().create()
        view.addSubview(acitvityIndicatorHud)
        acitvityIndicatorHud.setupView(color: UIColor.systemTeal, message: message)
        self.activityIndicatorHub = acitvityIndicatorHud
    }
    
    /**
     Subclasses override this method to create its own hud loader.
     
     This method allows subclasses to create custom hud loader. To create the default hud loader, use global configurations `DDConfigurations.localHudFactory`
     */
    open func activityIndicatorFactory() -> Factory<LocalHud> {
        return DDConfigurations.activityIndicatorFactory
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
    open func registerService() {}
    
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
        cleanUp()
    }
    
    /**
     Subclasses override this method to create custom back action for back button.
     
     By default, this will call pop action in navigation or dismiss in modal
     */
    open func onBack(_ sender: AnyObject) {
        let navigationSerview: NavigationService = DependencyManager.shared.getService()
        navigationSerview.pop()
    }
    
    private func bindLocalHud() {
        activityBag = DisposeBag()
        /// Bind Activity hub
        if let viewModel = viewModel, let activityIndicatorHub = activityIndicatorHub {
            viewModel.rxIndicator
                .asObservable()
                .bind(to: viewModel.rxShowLocalActivityIndicatorHud) => activityBag
            let shared = viewModel.rxShowLocalActivityIndicatorHud.distinctUntilChanged()
            shared ~> activityIndicatorHub.rx.show => activityBag
            shared.subscribe(onNext: localHudToggled) => activityBag
        }
    }
    
    /**
     Subclasses override this method to do more action when `viewModel` changed.
     */
    open func viewModelChanged() {
        viewModel?.reactIfNeeded()
    }
    
    private func cleanUp() {
        disposeBag = nil
        activityBag = nil
    }
    
    func updateAfterViewModelChanged() {
        bindViewAndViewModel()
        
        localeService.rxLocaleState.subscribe(onNext: {[weak self] _ in
            self?.onUpdateLocalize()
            self?.viewModel?.onUpdateLocalize()
        }) => disposeBag
        
        viewModelChanged()
    }
}
