//
//  ImagePickerViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/5/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift
import Action

class ImagePickerViewModel: BaseViewModel {
    let rxImage = BehaviorRelay<UIImage?>(value: nil)
    
    override func react() {
        super.react()
        rxImage.subscribe(onNext: { (image) in
            
        }) => disposeBag
    }
    
    private func addImage() {
        openCameraRoll()
    }
}
