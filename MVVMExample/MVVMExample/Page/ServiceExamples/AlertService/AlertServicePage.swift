//
//  AlertServicePage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 7/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class AlertServicePage: BasePage {
    @IBOutlet private weak var okayAlertBtn: UIButton!
    @IBOutlet private weak var submitAlertBtn: UIButton!
    @IBOutlet private weak var actionSheetAlertBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        super.initialize()
        /// guard let viewModel = self.viewModel as? AlertServiceViewModel else { return }
        enableBackButton = true
        DependencyManager.shared.registerService(Factory<AlertService> { AlertService() })
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? AlertServiceViewModel else {
            return
        }
        
        okayAlertBtn.rx.bind(to: viewModel.okayAlertAction, input: ())
        submitAlertBtn.rx.bind(to: viewModel.submitAlertAction, input: ())
        actionSheetAlertBtn.rx.bind(to: viewModel.actionSheetAlertAction, input: ())
        
        viewModel.rxConfirmAction.subscribe(onNext: { confirm in
            print("DEBUG: Confirm action did change \(confirm)")
        }) => disposeBag
        
        viewModel.rxOkayAction.subscribe(onNext: { confirm in
            print("DEBUG: Okay Action did change \(confirm)")
        }) => disposeBag
        
        viewModel.rxActionSheetAction.subscribe(onNext: { result in
            print("DEBUG: Action Sheet did change \(result)")
        }) => disposeBag
    }
}
