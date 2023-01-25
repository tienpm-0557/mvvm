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
        return Action { .just(self.onBack()) }
    }()

    public var animatorDelegate: AnimatorDelegate?
    public let alertService: IAlertService = DependencyManager.shared.getService()
    public let localeService: LocalizeService = DependencyManager.shared.getService()
    public let navigationService: NavigationService = DependencyManager.shared.getService()

    private var _viewModel: BaseViewModel?
    private var readyToBind = false

    public private(set) var viewModel: BaseViewModel? {
        get { return _viewModel }
        set {
            if _viewModel != newValue {
                disposeBag = DisposeBag()
                _viewModel = newValue
                viewModelChanged()
            }
        }
    }

    public convenience init(viewModel: BaseViewModel) {
        self.init()
        self.viewModel = viewModel
        initialize()
        updateAfterViewModelChanged()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.viewDidLoad = true
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
        /// React in case init viewmodel without Model. So, model changed not call.
        viewModel?.reactIfNeeded()
        if readyToBind {
            /// In case view change view model we need rebind view and view model
            self.bindViewAndViewModel()
        }
    }

    private func cleanUp() {
        disposeBag = nil
    }

    func updateAfterViewModelChanged() {
        bindViewAndViewModel()
        viewModelChanged()
        readyToBind = true
        localeService.rxLocaleState.subscribe(onNext: {[weak self] _ in
            self?.onUpdateLocalize()
            self?.viewModel?.onUpdateLocalize()
        }) => disposeBag
    }

    deinit {
        destroy()
    }
}
