//
//  TabbarControllerViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/31/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class TabbarControllerViewModel: BaseViewModel {
    let rxSelectedIndex = BehaviorRelay(value: 0)
    override func react() {
        super.react()
    }
}
