//
//  IntroductionPage.swift
//  MVVM_Example
//
//  Created by pham.minh.tien on 5/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift
import WebKit
import Action

class IntroductionPage: BaseWebView {
    @IBOutlet private var btnBack: UIButton!
    @IBOutlet private var btnForward: UIButton!
    @IBOutlet private var lbLoading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        enableBackButton = (navigationController?.viewControllers.count ?? 0) > 0
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? IntroductionPageViewModel else { return }
        btnBack.addTarget(self, action: #selector(self.goBack), for: UIControl.Event.touchUpInside)
        btnForward.addTarget(self, action: #selector(self.goForward), for: UIControl.Event.touchUpInside)
        
        viewModel.rxPageTitle ~> rx.title => disposeBag
        // Bind url in case load content from url.
        viewModel.rxURL ~> self.wkWebView.rx.url => disposeBag
        // Bind source in case load content from html file.
        viewModel.rxSource ~> self.wkWebView.rx.sourceHtml => disposeBag
        
        viewModel.rxCanGoBack ~> self.btnBack.rx.isEnabled => disposeBag
        viewModel.rxCanGoForward ~> self.btnForward.rx.isEnabled => disposeBag
        viewModel.rxIsLoading.subscribe(onNext: { (value) in
            if value {
                self.lbLoading.text = "Loading"
            } else {
                self.lbLoading.text = "Loaded"
            }
        }) => disposeBag
        
        //Subcribe estimated progress
        viewModel.rxEstimatedProgress.subscribe(onNext: { (prgress) in
            self.lbLoading.text = "Loading \(Int(prgress * 100))%"
        }) => disposeBag
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.bringSubviewToFront(btnBack)
        self.view.bringSubviewToFront(btnForward)
        self.view.bringSubviewToFront(lbLoading)
        
    }
    
    @objc func goBack() {
        self.wkWebView.goBack()
     }
     
     @objc func goForward() {
         self.wkWebView.goForward()
     }
}
