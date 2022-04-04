//
//  ValidatePageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 6/1/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Action

class ValidatePageViewModel: BaseViewModel {
    
    let rxPageTitle = BehaviorRelay<String?>(value: "")
    let rxHelloText = BehaviorRelay<String?>(value: nil)
    let rxEmail = BehaviorRelay<String?>(value: nil)
    let rxPass = BehaviorRelay<String?>(value: nil)
    let rxSubmitButtonEnabled = BehaviorRelay(value: false)
    
    lazy var submitAction: Action<Void, Void> = {
        return Action(enabledIf: self.rxSubmitButtonEnabled.asObservable()) {
            let email = self.rxEmail.value ?? ""
            let pass = self.rxPass.value ?? ""
            self.alertService.presentOkayAlert(title: "Submit Button Clicked!",
                                               message: "You have just clicked on submit button. Here are your credentials:\nEmail: \(email)\nPass: \(pass)")
            return .just(())
        }
    }()
    
    let alertService: IAlertService = DependencyManager.shared.getService()
    
    override func react() {
        guard let model = self.model as? MenuModel else { return }
        rxPageTitle.accept(model.title)
        
        Observable.combineLatest(rxEmail, rxPass) { e, p -> Bool in
            return !e.isNilOrEmpty && !p.isNilOrEmpty
        } ~> rxSubmitButtonEnabled => disposeBag // One-way binding is donated by ~>
        
        rxEmail.filter { $0 != nil }.map { "Hello, \($0!)" } ~> rxHelloText => disposeBag  // One-way binding is donated by ~>
    }

}
