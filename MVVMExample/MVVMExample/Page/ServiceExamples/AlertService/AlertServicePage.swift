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
    
    @IBOutlet private weak var submitBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        super.initialize()
        guard let viewModel = self.viewModel as? AlertServiceViewModel else { return }
        
        DependencyManager.shared.registerService(Factory<AlertService> { AlertService() })
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? AlertServiceViewModel else { return }
        
        submitBtn.rx.bind(to: viewModel.submitAction, input: ())
        viewModel.rxConfirmAction.subscribe(onNext: { (confirm) in
            print("DEBUG: confirmed \(confirm)")
        }) => disposeBag
    }
    
    

}
