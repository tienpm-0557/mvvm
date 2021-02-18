//
//  CustomControlViewPageModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 6/2/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Action

class CustomControlViewPageModel: BaseViewModel {
    
    let rxPageTitle = BehaviorRelay<String>(value: "")
    let rxSelectedIndex = BehaviorRelay(value: 0)
    let rxSelectedText = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        guard let model = self.model as? MenuModel else {
            return
        }
        rxPageTitle.accept(model.title)
        rxSelectedIndex.map { "You have selected Tab \($0 + 1)" } ~> rxSelectedText => disposeBag
    }
}
