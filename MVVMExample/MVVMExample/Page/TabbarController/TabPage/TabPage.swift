//
//  TabPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class TabPage: BasePage {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initialize() {
        super.initialize()
        guard let model = self.viewModel as? TabPageViewModel else {
            return
        }
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? TabPageViewModel else { return }
        
        viewModel.rxTille ~> self.rx.title => disposeBag
        
    }
    

}
