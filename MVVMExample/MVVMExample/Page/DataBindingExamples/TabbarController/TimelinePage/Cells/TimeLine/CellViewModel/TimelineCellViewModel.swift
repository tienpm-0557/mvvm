//
//  TimelineCellViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class TimelineCellViewModel: BaseCellViewModel {
    let rxTitle = BehaviorRelay<String?>(value: "")
    let rxDescription = BehaviorRelay<String?>(value: "")
    let rxCreateDate = BehaviorRelay<String?>(value: "")
    let rxReaction = BehaviorRelay<String?>(value: "")
    let rxThumbnail = BehaviorRelay(value: NetworkImage())
       
    override func react() {
        super.react()
        guard let model = self.model as? TimelineModel else { return }
        
        rxTitle.accept(model.title)
        rxDescription.accept(model.desc)
        
        rxCreateDate.accept(model.createDate)
        rxReaction.accept("\(model.reaction)")
        if let thumbnail = URL(string: model.thumbnail) {
            rxThumbnail.accept(NetworkImage(withURL: thumbnail, placeholder: UIImage.from(color: .black)))
        }
    }
    
}
