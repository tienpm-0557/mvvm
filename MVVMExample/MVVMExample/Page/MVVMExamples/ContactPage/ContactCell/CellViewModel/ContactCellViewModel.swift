//
//  ContactCellViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/22/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class ContactCellViewModel: BaseCellViewModel {
    let rxName = BehaviorRelay<String?>(value: nil)
    let rxPhone = BehaviorRelay<String?>(value: nil)

    override func react() {
        super.react()
        modelChanged()
    }

    override func modelChanged() {
        super.modelChanged()
        guard let model = self.model as? ContactModel else {
            return
        }
        rxName.accept(model.name)
        rxPhone.accept(model.phone)
    }
}
