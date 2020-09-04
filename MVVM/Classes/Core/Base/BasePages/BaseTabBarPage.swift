//
//  BaseTabBarPage.swift
//  Action
//
//  Created by pham.minh.tien on 8/31/20.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import PureLayout


open class BaseTabBarPage: UITabBarController, ITransitionView {
    
    public var disposeBag: DisposeBag? = DisposeBag()
    public private(set) var backButton: UIBarButtonItem?
    
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
    
    private lazy var backAction: Action<Void, Void> = {
        return Action() { .just(self.onBack()) }
    }()
    
    public var animatorDelegate: AnimatorDelegate?
    
    public let alertService: IAlertService = DependencyManager.shared.getService()
    public let localeService: LocalizeService = DependencyManager.shared.getService()
    public let navigationService: INavigationService = DependencyManager.shared.getService()
    
    deinit {
        destroy()
    }
    
    public private(set) var viewModel: BaseViewModel?
    
    public convenience init(viewModel vm: BaseViewModel) {
        self.init()
        self.viewModel = vm
        initialize()
        updateAfterViewModelChanged()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            destroy()
        }
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
    
    open func onBack() {
        navigationService.pop()
    }
    
    /**
     Subclasses override this method to remove all things related to `DisposeBag`.
     */
    open func destroy() {
        cleanUp()
    }
    
    /**
     Subclasses override this method to do more action when `viewModel` changed.
     */
    open func viewModelChanged() {
        viewModel?.reactIfNeeded()
    }
    
    private func cleanUp() {
        disposeBag = nil
    }
    
    func updateAfterViewModelChanged() {
        bindViewAndViewModel()
        
        localeService.rxLocaleState.subscribe(onNext: {[weak self] (newLocale) in
            self?.onUpdateLocalize()
            self?.viewModel?.onUpdateLocalize()
        }) => disposeBag
        
        viewModelChanged()
    }

}
