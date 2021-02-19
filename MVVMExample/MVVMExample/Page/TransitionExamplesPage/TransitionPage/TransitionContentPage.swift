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
    @IBOutlet private weak var label: UILabel!
    
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
        self.view.backgroundColor = UIColor(hexString: model.background)
    }
    
    override func initialize() {
        super.initialize()
        enableBackButton = true
        
        guard let model = self.viewModel?.model as? TransitionContentModel else {
            return
        }
        
        label.text = model.desc
    }
    
    override func onBack(_ sender: AnyObject) {
        if navigationController?.presentingViewController != nil {
            navigationService.pop(with: PopOptions(popType: .dismiss, animated: true))
        } else {
            super.onBack(sender)
        }
    }
}
