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
        
        addBtn.rx.bind(to: viewModel.addAction, input: ())
    }

    
}
