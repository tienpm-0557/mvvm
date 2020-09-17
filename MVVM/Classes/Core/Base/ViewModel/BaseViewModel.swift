//
//  BaseViewModel.swift
//  Action
//
//  Created by pham.minh.tien on 5/3/20.
//

import Foundation
import RxSwift
import RxCocoa
import WebKit

//MARK: Nongeneric Type
// Base view model sẽ đi với View tương ứng.
// Mỗi View model sẽ đi với một Base Model tưng ứng.

open class BaseViewModel: NSObject, IViewModel, IReactable {
    
    public typealias ModelElement = Model
    
    private var _model: Model?
    public var model: Model? {
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
    
    public var scheduler: SchedulerType?
    
    public required init(model: Model?) {
        _model = model
    }
    
    required public init(model: Model? = nil, timerScheduler: SchedulerType? = Scheduler.shared.mainScheduler) {
        _model = model
        scheduler = timerScheduler
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
    
    open func onUpdateLocalize() {}
    
    func reactIfNeeded() {
        guard !isReacted else { return }
        isReacted = true
        
        react()
    }
    
}

open class BaseListViewModel: BaseViewModel, IListViewModel {
    
    public typealias CellViewModelElement = BaseCellViewModel
    
    public typealias ItemsSourceType = [SectionList<BaseCellViewModel>]
    
    public let itemsSource = ReactiveCollection<BaseCellViewModel>()
    public let rxSelectedItem = BehaviorRelay<BaseCellViewModel?>(value: nil)
    public let rxSelectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    public let rxState = BehaviorRelay<ListState>(value: .normal)
    
    public var page: Int = 0
    public var limit: Int = 20
    
    required public init(model: Model? = nil, timerScheduler: SchedulerType? = Scheduler.shared.mainScheduler) {
        super.init(model: model, timerScheduler: timerScheduler)
    }
    
    public required init(model: Model?) {
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
    
    open func selectedItemDidChange(_ cellViewModel: BaseCellViewModel) { }
    open func loadMoreContent() {}
}

/**
A based ViewModel for TableCell and CollectionCell

The difference between ViewModel and CellViewModel is that CellViewModel does not contain NavigationService. Also CellViewModel
contains its own index
*/

open class BaseCellViewModel: NSObject, IGenericViewModel, IIndexable, IReactable {
    
    public typealias ModelElement = Model
    
    private var _model: Model?
    public var model: Model? {
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
    
    public required init(model: Model? = nil) {
        _model = model
    }

    open func modelChanged() {}
    open func react() {}
    
    func reactIfNeeded() {
        guard !isReacted else { return }
        isReacted = true
        react()
    }
    
    open func destroy() {
        disposeBag = DisposeBag()
    }
}

public enum WebViewSuorceType: String {
    case url = "url"
    case html = "html"
}

open class BaseWebViewModel: BaseViewModel {
    
    public let rxSourceType = BehaviorRelay<String>(value: WebViewSuorceType.url.rawValue)
    public let rxSource = BehaviorRelay<String?>(value: "")
    public let rxEstimatedProgress = BehaviorRelay<Double>(value: 0.0)
    
    public let rxCanGoBack = BehaviorRelay<Bool>(value:false)
    public let rxCanGoForward = BehaviorRelay<Bool>(value:false)
    public let rxIsLoading = BehaviorRelay<Bool>(value:false)
    
    open func webView(_ webView: WKWebView, estimatedProgress:Double) {}
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {}
    
    open func webView(_ webView: WKWebView, evaluateJavaScript:(event: Any?, error: Error?)?) {}
          
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) { completionHandler() }
          
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {completionHandler(false)}
          
    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {completionHandler(.useCredential, nil)}
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {}
          
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }
    
}

open class PageOption {
    public var isInfinity: Bool = false
    public var transitionStyle: Int = 0
    
}

open class BaseUIPageViewModel: BaseViewModel {
    
    public let itemsSource = ReactiveCollection<UIPageItem>()
    public let rxSelectedItem = BehaviorRelay<UIPageItem?>(value: nil)
    public let rxSelectedIndex = BehaviorRelay<Int>(value: 0)
    public let rxState = BehaviorRelay<ListState>(value: .normal)
    
    public var isInfinity: Bool = false
    
    required public init(model: Model? = nil, timerScheduler: SchedulerType? = Scheduler.shared.mainScheduler) {
        super.init(model: model, timerScheduler: timerScheduler)
    }
    
    public required init(model: Model?) {
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
    
    open func selectedItemDidChange(_ cellViewModel: BaseCellViewModel) { }
    open func loadMoreContent() {}
}

open class UIPageItem: NSObject, IReactable {
    
    public internal(set) var pageIndex: Int = 0
    public var disposeBag: DisposeBag? = DisposeBag()
       
    var isReacted = false
    
    private var _model: Model?
    public var vc: UIViewController?
    
    public required init(model: Model? = nil, viewController: UIViewController? = nil) {
        self._model = model
        self.vc = viewController
    }
   
    open func modelChanged() {}
    open func react() {}
       
    func reactIfNeeded() {
        guard !isReacted else { return }
        isReacted = true
        react()
    }
          
    open func destroy() {
        disposeBag = DisposeBag()
    }
    
}
