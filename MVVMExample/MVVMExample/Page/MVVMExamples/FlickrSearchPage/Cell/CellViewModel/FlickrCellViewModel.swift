//
//  FlickrCellViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/23/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class FlickrCellViewModel: BaseCellViewModel {    
    let rxImage = BehaviorRelay(value: NetworkImage())
    let rxTitle = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        guard let model = self.model as? FlickrPhotoModel else {
            return
        }
        rxImage.accept(NetworkImage(withURL: model.imageUrl, placeholder: UIImage.from(color: .black)))
        rxTitle.accept(model.title)
    }
}
