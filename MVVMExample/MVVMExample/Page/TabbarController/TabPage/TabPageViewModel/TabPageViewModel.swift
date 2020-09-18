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
    
    let rxTille = BehaviorRelay<String>(value: "")
    
    override func react() {
        super.react()
        guard let model = self.model as? TabbarModel else {
            return
        }
        rxTille.accept(model.title)
        
    }
}
