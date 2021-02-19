//
//  IntroductionViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

// MARK: ViewModel For BaseWebView Examples
class IntroductionPageViewModel: BaseWebViewModel {    
    let rxPageTitle = BehaviorRelay(value: "")
    let rxURL = BehaviorRelay<URL?>(value: nil)
        
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Table Of Contents"
        let url = URL(string: "https://tienpm-0557.github.io/mvvm")!

        rxPageTitle.accept(title)
        rxURL.accept(url)
    }
    
    override func webView(_ webView: WKWebView, estimatedProgress: Double) {
        self.rxEstimatedProgress.accept(estimatedProgress)
        print("DEBUG: estimatedProgress \(estimatedProgress)")
    }
}
