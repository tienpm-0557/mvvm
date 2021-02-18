//
//  SimpleListPageCellViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import RxCocoa
import MVVM

class SimpleListPageCellViewModel: BaseCellViewModel {
    let rxTitle = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        guard let viewModel = model as? SimpleModel else {
            return
        }
        rxTitle.accept(viewModel.title)
    }
}
