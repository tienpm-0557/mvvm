//
//  StoreKitPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import RxCocoa
import MVVM
import RxSwift

class StoreKitPage: BasePage {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initialize() {
        super.initialize()
        guard let cellModel = viewModel?.model as? MenuModel else {
            return
        }
        
        self.rx.title.onNext(cellModel.title)
        
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
    }

}
