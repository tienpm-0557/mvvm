//
//  HandleUserContentControllerWebPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 22/04/2021.
//  Copyright © 2021 Sun*. All rights reserved.
//

import UIKit
import MVVM

class WebKitExamplePage: BaseWebView {
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? WebKitExamplePageViewModel else {
            return
        }
        viewModel.rxSource ~> self.wkWebView.rx.sourceHtml => disposeBag
        viewModel.rxPageTitle ~> rx.title => disposeBag
        /// Simple solution is Adopt a WKScriptMessageHandler in View Model
        self.wkWebView.configuration.userContentController.add(viewModel, name: "RxWebKitScriptMessageHandler")
        /// You can user `configuration.userContentController.rx.scriptMessage(forName:)` instead WKScriptMessageHandler
        /// You can received your message with `subcriptMessage(forName: )`.
        /*
        self.wkWebView.configuration.userContentController.rx.scriptMessage(forName: "RxWebKitScriptMessageHandler").bind(onNext: { message in
            let alert = UIAlertController(title: "Evaluate Java Script",
                                          message: (message.body as? String) ?? "",
                                          preferredStyle: .alert)
    
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: .cancel,
                                          handler: nil))
            
            self.navigationService.push(to: alert, options: .modal())

        })
         */
    }
}
