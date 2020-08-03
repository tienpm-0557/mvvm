//
//  TransitionContentPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/3/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift
import Action

class TransitionContentPage: BasePage {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let model = self.viewModel?.model as? TransitionContentModel else {
            return
        }
        self.rx.title.onNext(model.title)
    }
    
    override func initialize() {
        super.initialize()
        enableBackButton = true
        
        guard let model = self.viewModel?.model as? TransitionContentModel else {
            return
        }
        
        let label = UILabel()
        label.text = model.desc
//        "Did you see the page zoom and switch?"
        view.addSubview(label)
        label.autoCenterInSuperview()
    }
    
    override func onBack() {
        if navigationController?.presentingViewController != nil {
            navigationService.pop(with: PopOptions(popType: .dismiss, animated: true))
        } else {
            super.onBack()
        }
    }

}
