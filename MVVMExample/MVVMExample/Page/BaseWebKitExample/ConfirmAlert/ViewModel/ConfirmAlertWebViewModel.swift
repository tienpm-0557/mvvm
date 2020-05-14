//
//  ConfirmAlertWebViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

class ConfirmAlertWebViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Confirm Alert"
        let url = URL(string: "https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_confirm2")!
        
        rxPageTitle.accept(title)
        rxURL.accept(url)
    }
    
    override func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "JavaScriptConfirm", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            completionHandler(false)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        navigationService.push(to: alert, options: .modal())
    }
}
