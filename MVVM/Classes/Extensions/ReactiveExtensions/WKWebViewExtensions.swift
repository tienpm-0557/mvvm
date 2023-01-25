//
//  WKWebViewExtensions.swift
//  MVVM
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import Action

public extension Reactive where Base: WKWebView {
    var url: Binder<URL?> {
        return Binder(base) { view, url in
            if let url = url {
                view.stopLoading()
                view.load(URLRequest(url: url))
            }
        }
    }
    
    var sourceHtml: Binder<String?> {
        return Binder(base) { view, source in
            if let source = source {
                view.stopLoading()
                view.loadHTMLString(source, baseURL: nil)
            }
        }
    }
    
    var title: Observable<String?> {
        return self.observeWeakly(String.self, "title")
    }

    /**
     Reactive wrapper for `loading` property.
     */
    var loading: Observable<Bool> {
        return self.observeWeakly(Bool.self, "loading")
            .map { $0 ?? false }
    }

    /**
     Reactive wrapper for `estimatedProgress` property.
     */
    var estimatedProgress: Observable<Double> {
        return self.observeWeakly(Double.self, "estimatedProgress")
            .map { $0 ?? 0.0 }
    }
    
    /**
     Reactive wrapper for `canGoBack` property.
     */
    var canGoBack: Observable<Bool> {
        return self.observeWeakly(Bool.self, "canGoBack")
            .map { $0 ?? false }
    }

    /**
     Reactive wrapper for `canGoForward` property.
     */
    var canGoForward: Observable<Bool> {
        return self.observeWeakly(Bool.self, "canGoForward")
            .map { $0 ?? false }
    }
    
    /// Reactive wrapper for `evaluateJavaScript(_:completionHandler:)` method.
    ///
    /// - Parameter javaScriptString: The JavaScript string to evaluate.
    /// - Returns: Observable sequence of result of the script evaluation.
    func evaluateJavaScript(_ javaScriptString: String) -> Observable<Any?> {
        return Observable.create { [weak base] observer in
            base?.evaluateJavaScript(javaScriptString) { value, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(value)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

public typealias RxWKUIDelegate = DelegateProxy<WKWebView, WKUIDelegate>
public typealias RxWKNavigationDelegate = DelegateProxy<WKWebView, WKNavigationDelegate>

extension Reactive where Base: WKWebView {
    public typealias JSAlertEvent = (webView: WKWebView, message: String, frame: WKFrameInfo, handler: () -> Void)
    public typealias JSConfirmEvent = (webView: WKWebView, message: String, frame: WKFrameInfo, handler: (Bool) -> Void)
    public typealias CommitPreviewEvent = (webView: WKWebView, controller: UIViewController)
    
    /// Reactive wrapper for `navigationDelegate`.
    public var uiDelegate: DelegateProxy<WKWebView, WKUIDelegate> {
        return RxWKUIDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for
    /// `func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void)`
    public var javaScriptAlertPanel: ControlEvent<JSAlertEvent> {
        typealias WKCompletionHandler = @convention(block) () -> Void
        let source: Observable<JSAlertEvent> = uiDelegate
            .methodInvoked(.jsAlert).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let message = try castOrThrow(String.self, args[1])
                let frame = try castOrThrow(WKFrameInfo.self, args[2])
                var closureObject: AnyObject? = nil
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[3] as AnyObject
                }
                let completionBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(completionBlockPtr, to: WKCompletionHandler.self)
                return (view, message, frame, handler)
        }
        
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for
    /// `func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void)`
    public var javaScriptConfirmPanel: ControlEvent<JSConfirmEvent> {
        typealias WKConfirmHandler = @convention(block) (Bool) -> Void
        let source: Observable<JSConfirmEvent> = uiDelegate
            .methodInvoked(.jsConfirm).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let message = try castOrThrow(String.self, args[1])
                let frame = try castOrThrow(WKFrameInfo.self, args[2])
                var closureObject: AnyObject? = nil
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[3] as AnyObject
                }
                let confirmBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(confirmBlockPtr, to: WKConfirmHandler.self)
                return (view, message, frame, handler)
        }
        
        return ControlEvent(events: source)
    }
    
    /// Reactive wrappper for `func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController)`
    @available(iOS 10.0, *)
    public var commitPreviewing: ControlEvent<CommitPreviewEvent> {
        let source: Observable<CommitPreviewEvent> = uiDelegate
            .methodInvoked(.commitPreviewing)
            .map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let controller = try castOrThrow(UIViewController.self, args[1])
                return (view, controller)
        }
        
        return ControlEvent(events: source)
    }
}

open class RxWKUIDelegateProxy: RxWKUIDelegate, DelegateProxyType, WKUIDelegate {
    /// Type of parent object
    /// must be WKWebView!
    public weak private(set) var webView: WKWebView?
    
    /// Init with ParentObject
    public init(parentObject: ParentObject) {
        webView = parentObject
        super.init(parentObject: parentObject, delegateProxy: RxWKUIDelegateProxy.self)
    }
    
    /// Register self to known implementations
    public static func registerKnownImplementations() {
        self.register { parent -> RxWKUIDelegateProxy in
            RxWKUIDelegateProxy(parentObject: parent)
        }
    }
    
    /// Gets the current `WKUIDelegate` on `WKWebView`
    open class func currentDelegate(for object: ParentObject) -> WKUIDelegate? {
        return object.uiDelegate
    }
    
    /// Set the uiDelegate for `WKWebView`
    open class func setCurrentDelegate(_ delegate: WKUIDelegate?, to object: ParentObject) {
        object.uiDelegate = delegate
    }
}

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}

extension Reactive where Base: WKWebView {
    /// WKNavigationEvent emits a tuple that contains both
    /// WKWebView + WKNavigation
    public typealias WKNavigationEvent = (webView: WKWebView, navigation: WKNavigation)
    
    /// WKNavigationFailedEvent emits a tuple that contains both
    /// WKWebView + WKNavigation + Swift.Error
    public typealias WKNavigationFailEvent = (webView: WKWebView, navigation: WKNavigation, error: Error)
    
    /// ChallengeHandler this is exposed to the user on subscription
    public typealias ChallengeHandler = (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    /// WKNavigationChallengeEvent emits a tuple event of WKWebView + challenge + ChallengeHandler
    public typealias WKNavigationChallengeEvent = (webView: WKWebView, challenge: URLAuthenticationChallenge, handler: ChallengeHandler)
    
    /// DecisionHandler this is the block exposed to the user on subscription
    public typealias DecisionHandler = (WKNavigationResponsePolicy) -> Void
    /// WKNavigationResponsePolicyEvent emits a tuple event of  WKWebView + WKNavigationResponse + DecisionHandler
    public typealias WKNavigationResponsePolicyEvent = ( webView: WKWebView, reponse: WKNavigationResponse, handler: DecisionHandler)
    /// ActionHandler this is the block exposed to the user on subscription
    public typealias ActionHandler = (WKNavigationActionPolicy) -> Void
    /// WKNavigationActionPolicyEvent emits a tuple event of  WKWebView + WKNavigationAction + ActionHandler
    public typealias WKNavigationActionPolicyEvent = ( webView: WKWebView, action: WKNavigationAction, handler: ActionHandler)
    
    /// Reactive wrapper for `navigationDelegate`.
    public var delegate: DelegateProxy<WKWebView, WKNavigationDelegate> {
        return RxWKNavigationDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didCommit navigation: WKNavigation!)`.
    public var didCommitNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(.didCommitNavigation)
            .map { arg in
                let view = try castOrThrow(WKWebView.self, arg[0])
                let nav = try castOrThrow(WKNavigation.self, arg[1])
                return (view, nav)
            }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)`.
    public var didStartProvisionalNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(.didStartProvisionalNavigation)
            .map { arg in
                let view = try castOrThrow(WKWebView.self, arg[0])
                let nav = try castOrThrow(WKNavigation.self, arg[1])
                return (view, nav)
            }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)`
    public var didFinishNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(.didFinishNavigation)
            .map { arg in
                let view = try castOrThrow(WKWebView.self, arg[0])
                let nav = try castOrThrow(WKNavigation.self, arg[1])
                return (view, nav)
            }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webViewWebContentProcessDidTerminate(_ webView: WKWebView)`.
    @available(iOS 9.0, *)
    public var didTerminate: ControlEvent<WKWebView> {
        let source: Observable<WKWebView> = delegate
            .methodInvoked(.didTerminate)
            .map { try castOrThrow(WKWebView.self, $0[0]) }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)`.
    public var didReceiveServerRedirectForProvisionalNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(.didReceiveServerRedirectForProvisionalNavigation)
            .map { arg in
                let view = try castOrThrow(WKWebView.self, arg[0])
                let nav = try castOrThrow(WKNavigation.self, arg[1])
                return (view, nav)
            }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)`.
    public var didFailNavigation: ControlEvent<WKNavigationFailEvent> {
        let source: Observable<WKNavigationFailEvent> = delegate
            .methodInvoked(.didFailNavigation)
            .map { arg in
                let view = try castOrThrow(WKWebView.self, arg[0])
                let nav = try castOrThrow(WKNavigation.self, arg[1])
                let error = try castOrThrow(Swift.Error.self, arg[2])
                return (view, nav, error)
            }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)`.
    public var didFailProvisionalNavigation: ControlEvent<WKNavigationFailEvent> {
        let source: Observable<WKNavigationFailEvent> = delegate
            .methodInvoked(.didFailProvisionalNavigation)
            .map { arg in
                let view = try castOrThrow(WKWebView.self, arg[0])
                let nav = try castOrThrow(WKNavigation.self, arg[1])
                let error = try castOrThrow(Swift.Error.self, arg[2])
                return (view, nav, error)
            }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method
    /// `webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)`
    public var didReceiveChallenge: ControlEvent<WKNavigationChallengeEvent> {
        /// __ChallengeHandler is same as ChallengeHandler
        /// They are interchangeable, __ChallengeHandler is for internal use.
        /// ChallengeHandler is exposed to the user on subscription.
        /// @convention attribute makes the swift closure compatible with Objc blocks
        typealias WKChallengeHandler =  @convention(block) (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
        /*! @abstract Invoked when the web view needs to respond to an authentication challenge.
         @param webView The web view that received the authentication challenge.
         @param challenge The authentication challenge.
         @param completionHandler The completion handler you must invoke to respond to the challenge. The
         disposition argument is one of the constants of the enumerated type
         NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
         the credential argument is the credential to use, or nil to indicate continuing without a
         credential.
         @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
         */
        let source: Observable<WKNavigationChallengeEvent> = delegate
            .sentMessage(.didReceiveChallenge)
            .map { arg in
                /// Extracting the WKWebView from the array at index zero
                /// which is the first argument of the function signature
                let view = try castOrThrow(WKWebView.self, arg[0])
                /// Extracting the URLAuthenticationChallenge from the array at index one
                /// which is the second argument of the function signature
                let challenge = try castOrThrow(URLAuthenticationChallenge.self, arg[1])
                /// Now you `Can't` transform closure easily because they are excuted
                /// in the stack if try it you will get the famous error
                /// `Could not cast value of type '__NSStackBlock__' (0x12327d1a8) to`
                /// this is because closures are transformed into a system type which is `__NSStackBlock__`
                /// the above mentioned type is not exposed to `developer`. So everytime
                /// you execute a closure the compiler transforms it into this Object.
                /// So you go through the following steps to get a human readable type
                /// of the closure signature:
                /// 1. closureObject is type of AnyObject to that holds the raw value from
                /// the array.
                var closureObject: AnyObject? = nil
                /// 2. make the array mutable in order to access the `withUnsafeMutableBufferPointer`
                /// fuctionalities
                var mutableArg = arg
                /// 3. Grab the closure at index 3 of the array, but we have to use the C-style
                /// approach to access the raw memory underpinning the array and store it in closureObject
                /// Now the object stored in the `closureObject` is `Unmanaged` and `some unspecified type`
                /// the intelligent swift compiler doesn't know what sort of type it contains. It is Raw.
                mutableArg.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[2] as AnyObject
                }
                /// 4. instantiate an opaque pointer to referenc the value of the `unspecified type`
                let challengeBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                /// 5. Here the magic happen we forcefully tell the compiler that anything
                /// found at this memory address that is refrenced should be a type of
                /// `__ChallengeHandler`!
                let handler = unsafeBitCast(challengeBlockPtr, to: WKChallengeHandler.self)
                return (view, challenge, handler)
        }
        
        return ControlEvent(events: source)
        
        /**
         Reference:
         
         This is a holy grail part for more information please read the following articles.
         1: http://codejaxy.com/q/332345/ios-objective-c-memory-management-automatic-ref-counting-objective-c-blocks-understand-one-edge-case-of-block-memory-management-in-objc
         2: http://www.galloway.me.uk/2012/10/a-look-inside-blocks-episode-2/
         3: https://maniacdev.com/2013/11/tutorial-an-in-depth-guide-to-objective-c-block-debugging
         4: get know how [__NSStackBlock__ + UnsafeRawPointer + unsafeBitCast] works under the hood
         5: https://en.wikipedia.org/wiki/Opaque_pointer
         6: https://stackoverflow.com/questions/43662363/cast-objective-c-block-nsstackblock-into-swift-3
         */
    }
    
    /// Reactive wrapper for `func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void)`
    public var decidePolicyNavigationResponse: ControlEvent<WKNavigationResponsePolicyEvent> {
        typealias WKDecisionHandler = @convention(block) (WKNavigationResponsePolicy) -> Void
        let source: Observable<WKNavigationResponsePolicyEvent> = delegate
            .methodInvoked(.decidePolicyNavigationResponse).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let response = try castOrThrow(WKNavigationResponse.self, args[1])
                var closureObject: AnyObject? = nil
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[2] as AnyObject
                }
                let decisionBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(decisionBlockPtr, to: WKDecisionHandler.self)
                return (view, response, handler)
        }
        
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)`
    public var decidePolicyNavigationAction: ControlEvent<WKNavigationActionPolicyEvent> {
        typealias WKActionHandler = @convention(block) (WKNavigationActionPolicy) -> Void
        let source: Observable<WKNavigationActionPolicyEvent> = delegate
            .methodInvoked(.decidePolicyNavigationAction).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let action = try castOrThrow(WKNavigationAction.self, args[1])
                var closureObject: AnyObject? = nil
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[2] as AnyObject
                }
                let actionBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(actionBlockPtr, to: WKActionHandler.self)
                return (view, action, handler)
        }
        
        return ControlEvent(events: source)
    }
}

extension Selector {
    static let jsAlert = #selector(WKUIDelegate.webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:))
    static let jsConfirm = #selector(WKUIDelegate.webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:))
    @available(iOS 10.0, *)
    static let commitPreviewing = #selector(WKUIDelegate.webView(_:commitPreviewingViewController:))
    
    static let didCommitNavigation = #selector(WKNavigationDelegate.webView(_:didCommit:))
    static let didStartProvisionalNavigation = #selector(WKNavigationDelegate.webView(_:didStartProvisionalNavigation:))
    static let didFinishNavigation = #selector(WKNavigationDelegate.webView(_:didFinish:))
    static let didReceiveServerRedirectForProvisionalNavigation = #selector(WKNavigationDelegate.webView(_:didReceiveServerRedirectForProvisionalNavigation:))
    static let didFailNavigation = #selector(WKNavigationDelegate.webView(_:didFail:withError:))
    static let didFailProvisionalNavigation = #selector(WKNavigationDelegate.webView(_:didFailProvisionalNavigation:withError:))
    static let didReceiveChallenge = #selector(WKNavigationDelegate.webView(_:didReceive:completionHandler:))
    @available(iOS 9.0, *)
    static let didTerminate = #selector(WKNavigationDelegate.webViewWebContentProcessDidTerminate(_:))
    /// Xcode give error when selectors results into having same signature
    /// because of swift style you get for example:
    /// Ambiguous use of 'webView(_:decidePolicyFor:decisionHandler:)'
    /// please see this link for further understanding
    /// https://bugs.swift.org/browse/SR-3062
    static let decidePolicyNavigationResponse = #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:)
        as ((WKNavigationDelegate) -> (WKWebView, WKNavigationResponse, @escaping(WKNavigationResponsePolicy) -> Void) -> Void)?)
    static let decidePolicyNavigationAction = #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:)
        as ((WKNavigationDelegate) -> (WKWebView, WKNavigationAction, @escaping(WKNavigationActionPolicy) -> Void) -> Void)?)
}

extension WKUserContentController {
    fileprivate class MessageHandler: NSObject, WKScriptMessageHandler {
        typealias MessageReceiveHandler = (WKScriptMessage) -> Void
        
        private var messageReceiveHandler: MessageReceiveHandler?
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            self.messageReceiveHandler?(message)
        }
        
        func onReceive(_ handler:@escaping MessageReceiveHandler) {
            self.messageReceiveHandler = handler
        }
    }
}

public extension Reactive where Base: WKUserContentController {
    /// Observable sequence of script message.
    ///
    /// - Parameter name: The name of the message handler
    /// - Returns: Observable sequence of script message.
    func scriptMessage(forName name: String) -> ControlEvent<WKScriptMessage> {
        return ControlEvent(events: Observable.create { [weak base] observer in
            let handler = WKUserContentController.MessageHandler()
            base?.add(handler, name: name)
            handler.onReceive {
                observer.onNext($0)
            }
            return Disposables.create {
                base?.removeScriptMessageHandler(forName: name)
            }
        })
    }
}

open class RxWKNavigationDelegateProxy: RxWKNavigationDelegate, DelegateProxyType, WKNavigationDelegate {
    /// Type of parent object
    public weak private(set) var webView: WKWebView?
    
    /// Init with ParentObject
    public init(parentObject: ParentObject) {
        webView = parentObject
        super.init(parentObject: parentObject, delegateProxy: RxWKNavigationDelegateProxy.self)
    }
    
    /// Register self to known implementations
    public static func registerKnownImplementations() {
        self.register { parent -> RxWKNavigationDelegateProxy in
            RxWKNavigationDelegateProxy(parentObject: parent)
        }
    }
    
    /// Gets the current `WKNavigationDelegate` on `WKWebView`
    open class func currentDelegate(for object: ParentObject) -> WKNavigationDelegate? {
        return object.navigationDelegate
    }
    
    /// Set the navigationDelegate for `WKWebView`
    open class func setCurrentDelegate(_ delegate: WKNavigationDelegate?, to object: ParentObject) {
        object.navigationDelegate = delegate
    }
}
