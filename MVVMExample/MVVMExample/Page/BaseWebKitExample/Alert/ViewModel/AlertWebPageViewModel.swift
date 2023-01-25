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
        let html = """
        <!DOCTYPE html>
        <html>
        <body>
        <br><br><br><br><br><br><br>

        <h1><p>Click the button bellow to display an alert box.</p></h1>

        <button onclick="yourFunction()">Click Here</button>

        <script>
        function yourFunction() {
            alert("Hello! I am an alert box!");
        }
        </script>

        </body>
        </html>
        """
        rxPageTitle.accept(title)
        rxSourceType.accept(WebViewSuorceType.html.rawValue)
        rxSource.accept(html)
    }

    override func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "runJavaScriptAlertPanelWithMessage",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
                                        completionHandler()
                                      }))
        navigationService.push(to: alert, options: .modal())
    }
}
