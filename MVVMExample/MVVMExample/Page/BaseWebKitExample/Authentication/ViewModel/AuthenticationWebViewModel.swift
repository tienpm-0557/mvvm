//
//  AuthenticationWebViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

class AuthenticationWebViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Authentication"
        let url = URL(string: "https://jigsaw.w3.org/HTTP/Basic/")!
        rxPageTitle.accept(title)
        rxURL.accept(url)
    }

    override func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        /*
         The correct credentials are:
         user = guest
         password = guest
         
        You might want to start with the invalid credentials to get a sense of how this code works
        */
        let credential = URLCredential(user: "guest", password: "guest", persistence: URLCredential.Persistence.forSession)
        challenge.sender?.use(credential, for: challenge)
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
    }
}
