//
//  BaseUIPage.swift
//  Action
//
//  Created by pham.minh.tien on 9/4/20.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import PureLayout

open class BaseUIPage: UIPageViewController, ITransitionView, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
    
    public private(set) var viewModel: BaseUIPageViewModel?
    
    public convenience init(viewModel vm: BaseUIPageViewModel, withOption option: PageOption?) {
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
    
    open func getItemSource() -> ReactiveCollection<UIPageItem>? {
        fatalError("Subclasses have to implement this method.")
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
    open func initialize() {
        dataSource = self
        delegate = self
    }
    
    func setupPage() {
        guard let itemsSource = getItemSource() else { return }
        if let first = itemsSource.first?.allElements.first,
            let viewcontroller = first.vc {
            
            setViewControllers([viewcontroller],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
    }
    
    /**
     Subclasses override this method to create data binding between view and viewModel.
     
     This method always happens, so subclasses should check if viewModel is nil or not. For example:
     ```
     guard let viewModel = viewModel else { return }
     ```
     */
    open func bindViewAndViewModel() {
        
        getItemSource()?.collectionChanged
            .observeOn(Scheduler.shared.mainScheduler)
            .subscribe(onNext: { [weak self] indexPath in
                self?.onDataSourceChanged(indexPath)
            }) => disposeBag
        
    }
    
    
    private func onDataSourceChanged(_ changeSet: ChangeSet) {
        
    }
    
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
        setupPage()
    }
    
    fileprivate func nextViewController(_ viewController: UIViewController,
                                        isAfter: Bool) -> UIViewController? {
        
        guard let itemsSource = getItemSource() else { return nil }
        guard let allItems = itemsSource.first?.allElements else { return nil }

        var index = allItems.firstIndex {
            $0.vc == viewController
        } ?? 0
        
        if isAfter {
            index += 1
        } else {
            index -= 1
        }
        
        if let viewModel = self.viewModel {
            if viewModel.isInfinity {
                if index < 0 {
                    index = allItems.count - 1
                } else if index == allItems.count {
                    index = 0
                }
            } else {
                if index < 0 || index == allItems.count {
                    return nil
                }
            }
        }
        
        let nextItem = allItems[index]
        return nextItem.vc
    }
    /// MARK: - UIPageViewControllerDataSource
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: true)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: false)
    }
    
    /// MARK: - UIPageViewControllerDelegate
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    }
    
}
