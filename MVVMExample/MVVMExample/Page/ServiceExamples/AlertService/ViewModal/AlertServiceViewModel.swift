//
//  AlertServiceViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 7/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import Action
import RxSwift
import RxCocoa

class AlertServiceViewModel: BaseViewModel {
    var tmpBag: DisposeBag?
    var alertService: AlertService?
    let rxSubmitButtonEnabled = BehaviorRelay(value: true)
    let rxOkayAction = BehaviorRelay(value: true)
    let rxConfirmAction = BehaviorRelay(value: true)
    let rxActionSheetAction = BehaviorRelay<String>(value: "")
    
    lazy var okayAlertAction: Action<Void, Void> = {
        return Action(enabledIf: self.rxSubmitButtonEnabled.asObservable()) {
            self.alertService?.presentObservableOkayAlert(title:  "Okay Button Clicked!", message: "You have just clicked on okay button.").subscribe(onSuccess: { (result) in
                self.rxOkayAction.accept(true)
            }) => self.tmpBag
            return .just(())
        }
    }()
    
    
    lazy var submitAlertAction: Action<Void, Void> = {
        return Action(enabledIf: self.rxSubmitButtonEnabled.asObservable()) {
            self.alertService?.presentPMConfirmAlert(title: "Submit Button Clicked!",
                                                               message: "You have just clicked on submit button.? Do you want submit?",
                                                               yesText: "OK",
                                                               noText: "Cancel").subscribe(onSuccess: { (confirm) in
                                                                self.rxConfirmAction.accept(confirm)
                                                               }) => self.tmpBag
            
            return .just(())
        }
    }()
    
    
    lazy var actionSheetAlertAction: Action<Void, Void> = {
        return Action(enabledIf: self.rxSubmitButtonEnabled.asObservable()) {
            self.alertService?.presentObservaleActionSheet(title: "Action Sheet Button Clicked!",
                                                           message: "You have just clicked on action sheet button.? Do you want continue?",
                                                           actionTitles: ["OK"],
                                                           cancelTitle: "Cancel").subscribe(onSuccess: { (result) in
                                                            self.rxActionSheetAction.accept(result)
                                                           }) => self.tmpBag
            
            return .just(())
        }
    }()
    
    
    override func react() {
        super.react()
        alertService = DependencyManager.shared.getService()
    }

}
