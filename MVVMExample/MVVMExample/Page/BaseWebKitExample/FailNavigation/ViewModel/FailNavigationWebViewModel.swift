//
//  FailNavigationWebViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

class FailNavigationWebViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Fail Provisional Navigation"
        let url = URL(string: "https://thiswebsiteisnotexisting.com")!
        
        rxPageTitle.accept(title)
        rxURL.accept(url)
    }
    
    override func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "FailProvisionalNavigation", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        navigationService.push(to: alert, options: .modal())
    }
}
