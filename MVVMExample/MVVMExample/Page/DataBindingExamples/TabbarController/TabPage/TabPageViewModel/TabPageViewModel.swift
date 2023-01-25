//
//  TabPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Action

class TabPageViewModel: BaseViewModel {
    let rxTitle = BehaviorRelay<String?>(value: "")
    let rxName = BehaviorRelay<String?>(value: nil)
    let rxBackgroundHex = BehaviorRelay<String?>(value: "89DDF7")
    override func react() {
        super.react()
        guard let model = self.model as? TabbarModel else {
            return
        }
        rxTitle.accept(model.title)
        rxName.accept(model.title)
        if  !model.hex.isEmpty {
            rxBackgroundHex.accept(model.hex)
        }
    }
}
