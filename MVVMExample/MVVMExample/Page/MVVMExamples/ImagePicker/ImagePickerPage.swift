//
//  ImagePickerPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/5/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class ImagePickerPage: BasePage {
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        enableBackButton = true
        navigationItem.rightBarButtonItem = addBtn
    }

    override func initialize() {
        super.initialize()
        guard let model = self.viewModel?.model as? MenuModel else { return }
        self.rx.title.onNext(model.title)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel as? ImagePickerViewModel else { return }
        
        addBtn.rx.tap
            .flatMapLatest { [weak self]_ in
                return UIImagePickerController.rx.createWithParent(self, animated: true) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            }
            .map { info in
                return info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
            }
            .bind(to: viewModel.rxImage) => disposeBag
    }
}
