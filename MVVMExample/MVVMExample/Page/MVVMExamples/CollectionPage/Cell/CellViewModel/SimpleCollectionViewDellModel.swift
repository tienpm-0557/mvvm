//
//  SimpleCollectionViewDellModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class SimpleCollectionViewDellModel: BaseCellViewModel {
    let rxTitle = BehaviorRelay<String?>(value: nil)
    let rxDesc = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        guard let model = model as? SectionTextModel else {
            return
        }
        rxTitle.accept(model.title)
        rxDesc.accept(model.desc)
    }
}
