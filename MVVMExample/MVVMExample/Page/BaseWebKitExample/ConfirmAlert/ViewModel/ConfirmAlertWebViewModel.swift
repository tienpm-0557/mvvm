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
        
        let html = """
        <!DOCTYPE html>
        <html>
        <body>
        <br><br><br><br><br><br><br>
        <h1>Click the button bellow to display a confirm box.</h1>

        <button onclick="yourFunction()">Try it</button>

        <p id="demo"></p>
            
        <script>
        function yourFunction() {
          var txt;
          var r = confirm("Press a button!");
          if (r == true) {
            txt = "You pressed OK!";
          } else {
            txt = "You pressed Cancel!";
          }
          document.getElementById("demo").innerHTML = txt;
        }

        </script>

        </body>
        </html>
        """
        
        rxPageTitle.accept(title)
        rxSourceType.accept(WebViewSuorceType.html.rawValue)
        rxSource.accept(html)
    }
    
    override func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "JavaScriptConfirm", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: { _ in
                                        completionHandler(false)
                                      }))
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
                                        completionHandler(true)
                                      }))
        navigationService.push(to: alert, options: .modal())
    }
}
