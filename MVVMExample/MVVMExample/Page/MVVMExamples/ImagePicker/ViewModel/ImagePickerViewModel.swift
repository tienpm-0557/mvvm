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
    
    let rxTitle = BehaviorRelay<String?>(value: "")
    let rxDescription = BehaviorRelay<String?>(value: "What's on your mind?")
    let rxImage = BehaviorRelay<UIImage?>(value: nil)
    let rxCanPost = BehaviorRelay(value: false)

    lazy var postAction: Action<Void, Void> = {
        return Action(enabledIf: self.rxCanPost.asObservable()) {
            return .just(self.post())
        }
    }()
    
    
    override func react() {
        super.react()
        rxImage.subscribe(onNext: { (image) in
            
        }) => disposeBag
        
        Observable.combineLatest(rxTitle, rxDescription, rxImage) { title, desc, image in
            return !(title?.isEmpty ?? false) && !(desc?.isEmpty ?? false) && (image != nil)
        } ~> rxCanPost => disposeBag
    }
    
    private func post() {
        
    }
}
