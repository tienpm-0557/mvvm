//
//  WebKitExamplePageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 22/04/2021.
//  Copyright © 2021 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import WebKit

class WebKitExamplePageViewModel: BaseWebViewModel, WKScriptMessageHandler {
    let rxPageTitle = BehaviorRelay<String?>(value: "")
    override func react() {
        super.react()
        let title = (self.model as? MenuModel)?.title ?? "Confirm Alert"

        let html = """
        <!DOCTYPE html>
        <html>
        <body>
        <br><br><br><br><br><br><br>
        <h1>Click the button bellow to send a your message.</h1>

        <button onclick="yourReturnFunction()">Try it</button>

        <p id="demo"></p>

        <script>
        function yourReturnFunction() {
            window.webkit.messageHandlers.RxWebKitScriptMessageHandler.postMessage('🎊Congratulation! Your message sent success!🎉')
          return
        }
        </script>

        </body>
        </html>
        """
        rxPageTitle.accept(title)
        rxSourceType.accept(WebViewSuorceType.html.rawValue)
        rxSource.accept(html)
    }

    override func webView(_ webView: WKWebView, estimatedProgress: Double) {
        self.rxEstimatedProgress.accept(estimatedProgress)
        print("DEBUG: estimatedProgress \(estimatedProgress)")
    }

    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        let alert = UIAlertController(title: "Evaluate Java Script",
                                      message: (message.body as? String) ?? "",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .cancel,
                                      handler: nil))

        navigationService.push(to: alert, options: .modal())
    }
}
