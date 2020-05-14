//
//  BaseWebView.swift
//  Action
//
//  Created by pham.minh.tien on 5/8/20.
//

import Foundation
import WebKit
import RxSwift
import RxCocoa

open class BaseWebView: BasePage {
    
    private(set) public var wkWebView = WKWebView()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let originY = UIApplication.shared.statusBarFrame.maxY
        wkWebView.frame = CGRect(
            x: 0,
            y: originY,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
    }
    
    open override func initialize() {
        setupWebView(wkWebView)
    }
    
    open override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? BaseWebViewModel else {
            return
        }
        // Subscribe Java script alert panel.
        wkWebView.rx.javaScriptAlertPanel.subscribe(onNext: { webView, message, frame, handler in
            viewModel.webView(webView,
                              runJavaScriptAlertPanelWithMessage: message,
                              initiatedByFrame: frame,
                              completionHandler: handler)
        }) => disposeBag
        
        // Subcribe java script confirm panel.
        wkWebView.rx.javaScriptConfirmPanel.subscribe(onNext: { webView, message, frame, handler in
            viewModel.webView(webView,
                              runJavaScriptConfirmPanelWithMessage: message,
                              initiatedByFrame: frame,
                              completionHandler: handler)
        }) => disposeBag
        
        // Subcribe java did receive challenge
        wkWebView.rx.didReceiveChallenge.subscribe(onNext: {(webView, challenge, handler) in
            guard challenge.previousFailureCount == 0 else {
                   handler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                   return
            }
            viewModel.webView(webView,
                              didReceive: challenge,
                              completionHandler: handler)
        }) => disposeBag
        // Subcribe java did fail provisional navigation
        wkWebView.rx.didFailProvisionalNavigation.observeOn(MainScheduler.instance).subscribe(onNext: { webView, navigation, error in
            viewModel.webView(webView,
                              didFailProvisionalNavigation: navigation,
                              withError: error)
        }) => disposeBag
        
        // Subcribe java did receive policy navigation action
        wkWebView.rx.decidePolicyNavigationAction.observeOn(MainScheduler.instance).subscribe(onNext: { (webview, navigation, handler) in
            viewModel.webView(webview,
                              decidePolicyFor: navigation,
                              decisionHandler: handler)
        }) => disposeBag
        
        // Subcribe java did receive policy navigation response
        wkWebView.rx.decidePolicyNavigationResponse.observeOn(MainScheduler.instance).subscribe(onNext: { (webview, response, handler) in
            viewModel.webView(webview,
                              decidePolicyFor: response,
                              decisionHandler: handler)
        }) => disposeBag
        
        
        // Subcribe did finish navigation
        wkWebView.rx.didFinishNavigation.observeOn(MainScheduler.instance).subscribe(onNext: { (webView, navigation) in
            viewModel.webView(webView,
                              didFinish: navigation)
        }) => disposeBag
        
        wkWebView.rx.estimatedProgress.share(replay: 1).subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            viewModel.webView(self.wkWebView, estimatedProgress: value)
        }) => disposeBag

        wkWebView.rx.loading.share(replay: 1).subscribe(onNext: { isLoading in
            viewModel.rxIsLoading.accept(isLoading)
        }) => disposeBag

        wkWebView.rx.canGoBack.share(replay: 1).subscribe(onNext: { canGoBack in
            viewModel.rxCanGoBack.accept(canGoBack)
        }) => disposeBag

        wkWebView.rx.canGoForward.share(replay: 1).subscribe(onNext: { canForward in
            viewModel.rxCanGoForward.accept(canForward)
        }) => disposeBag
    }
    
    
    // Call function in java script.
    /* E.g: In the page have a script function
     <script>
     function presentAlert() {
        do something
     }
     </script>
     Use: evaluateJavaScript("presentAlert()")
     */
    public func evaluateJavaScript(_ function: String) {
        guard let viewModel = self.viewModel as? BaseWebViewModel else {
            return
        }
        wkWebView.rx.evaluateJavaScript(function).observeOn(MainScheduler.asyncInstance).subscribe {[weak self]  event in
            guard let self = self else {return}
            if case .next(let ev) = event {
                viewModel.webView(self.wkWebView, evaluateJavaScript: (ev, nil))
            } else if case .error(let error) = event {
                viewModel.webView(self.wkWebView, evaluateJavaScript: (nil, error))
            }
        } => disposeBag
    }
    
    func setupWebView(_ webView: WKWebView) {
        self.view.addSubview(webView)
    }
        
    open override func destroy() {
        super.destroy()
    }
    
    
}

