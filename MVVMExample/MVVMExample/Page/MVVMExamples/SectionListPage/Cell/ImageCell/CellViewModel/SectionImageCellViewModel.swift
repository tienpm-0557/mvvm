//
//  SectionImageCellViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class SectionImageCellViewModel: BaseCellViewModel {
    
    let rxImage = BehaviorRelay(value: NetworkImage())
    
    override func react() {
        guard let model = model as? SectionImageModel else {
            return
        }
        rxImage.accept(NetworkImage(withURL: model.imageUrl, placeholder: .from(color: .lightGray)))
    }
}
