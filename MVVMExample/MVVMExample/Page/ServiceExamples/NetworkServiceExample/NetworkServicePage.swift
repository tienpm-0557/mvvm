//
//  NetworkServicePage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/26/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class NetworkServicePage: BasePage {

    override func viewDidLoad() {
        super.viewDidLoad()
        enableBackButton = true
        // Do any additional setup after loading the view.
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? NetworkServicePageViewModel else {
            return
        }
        
        viewModel.rxPageTitle ~> self.rx.title => disposeBag
        
    }
    

}
