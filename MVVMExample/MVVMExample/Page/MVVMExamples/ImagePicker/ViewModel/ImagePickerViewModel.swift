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
    
    lazy var addAction: Action<Void, Void> = {
        return Action() { .just(self.addImage())}
    }()
    
    override func react() {
        super.react()
    }
    
    private func addImage() {
        openCameraRoll()
    }
    
    
    private func openCameraRoll() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            
            self.navigationService.push(to: picker, options: .modal(presentationStyle: .fullScreen, animator: nil))
        }
    }
}
