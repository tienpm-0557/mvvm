//
//  AlertWebPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

class AlertWebPageViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Alert Panel With message"
        let url = URL(string: "https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_alert")!
        
        rxPageTitle.accept(title)
        rxURL.accept(url)
    }
    
    override func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "runJavaScriptAlertPanelWithMessage", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        navigationService.push(to: alert, options: .modal())
    }

}
