//
//  TransitionExamplesPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit

//MARK: ViewModel For Transition Examples
class TransitionExamplesPageViewModel: BaseViewModel {
    
    let rxPageTitle = BehaviorRelay<String>(value: "")
    
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Transition Examples"
        rxPageTitle.accept(title)
    }
    
    
    
}
