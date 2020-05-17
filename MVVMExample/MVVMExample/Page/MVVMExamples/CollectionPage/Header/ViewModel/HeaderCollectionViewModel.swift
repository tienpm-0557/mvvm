//
//  HeaderCollectionViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxSwift
import RxCocoa
import Action

class HeaderCollectionViewModel: BaseViewModel {
    
    let rxTitle = BehaviorRelay<String?>(value: nil)
    let rxFooter = BehaviorRelay<String?>(value: nil)
    let rxDesc = BehaviorRelay<String?>(value: nil)
        
    override func react() {
        guard let model = model as? HeaderFooterModel else { return }
        rxTitle.accept(model.title)
        rxFooter.accept(model.footer)
        rxDesc.accept(model.desc)
    }
}
