//
//  EvaluateJavaScriptWebViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

class EvaluateJavaScriptWebViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        
        let title = (self.model as? IntroductionModel)?.title ?? "Evaluate JavaScript"
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <title>Invoke Javascript function</title>
        </head>
        <body>

        <h1>Invoke Javascript function</h1>
        <h1>Just Press 'Invoke' at top right corner.</h1>
        <h1>After that, pay attention to your console.</h1>

        <script>
        function presentAlert() {
            return "🎊🎊🎊Hey! you just invoke me🎉🎉🎉"
        }
        </script>

        </body>
        </html>
        """

        rxPageTitle.accept(title)
        rxSourceType.accept(WebViewSuorceType.html.rawValue)
        rxSource.accept(html)
        
    }
    
    override func webView(_ webView: WKWebView, evaluateJavaScript: (event: Any?, error: Error?)?) {
        if let event = evaluateJavaScript?.event as? String {
            let alert = UIAlertController(title: "Evaluate Java Script", message: event, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            navigationService.push(to: alert, options: .modal())
        }
    }
}

