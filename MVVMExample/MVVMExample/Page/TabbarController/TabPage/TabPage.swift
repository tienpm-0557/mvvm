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

    override func initialize() {
        super.initialize()
        guard let modelView = self.viewModel as? TabPageViewModel else {
            return
        }
        
        modelView.rxTille ~> self.rx.title => disposeBag
    }

}
