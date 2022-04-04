//
//  ReachabilityViewModel.swift
//  MVVMExample
//
//  Created by dinh.tung on 7/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import MVVM
import RxCocoa
import WebKit
import Reachability
import Action
import UIKit
import RxSwift
import RxCocoa


//MARK: ViewModel For Transition Examples
class ReachabilityPageViewModel: BaseViewModel {
    
    var reachibilityService: ReachabilityService?
    let rxPageTitle = PublishSubject<String?>()
    let rxAlertLabelContent = PublishSubject<String?>()
    
    let rxReachbilityState = PublishSubject<(connection:Reachability.Connection, alertType: AlertType)>()
    
    private var alertType = AlertType.disposableAlert
    
    lazy var rxDisposableAlertAction: Action<Void, Void> = {
        return Action() {_ in
            return .just(
                self.disposableAlert()
            )
        }
    }()
    
    lazy var rxDialogAlertAction: Action<Void, Void> = {
        return Action() {_ in
            return .just(
                self.dialogAlert()
            )
        }
    }()
    
    override func react() {
        super.react()
        let title = "Reachability Examples"
        rxPageTitle.onNext(title)
        reachibilityService = DependencyManager.shared.getService()
        reachibilityService?.startReachability()
        reachibilityService?.connectState.subscribe(onNext: { (state) in
            guard let state = state else { return }
            switch state.description {
            case Reachability.Connection.wifi.description:
                self.rxReachbilityState.onNext((Reachability.Connection.wifi, self.alertType))
            case Reachability.Connection.cellular.description:
                self.rxReachbilityState.onNext((Reachability.Connection.cellular, self.alertType))
            case Reachability.Connection.unavailable.description:
                self.rxReachbilityState.onNext((Reachability.Connection.unavailable, self.alertType))
                self.rxAlertLabelContent.onNext("No internet connection")
            default:
                self.rxReachbilityState.onNext((Reachability.Connection.unavailable, self.alertType))
                self.rxAlertLabelContent.onNext("No internet connection")
            }
        }) => disposeBag
    }
    
    func disposableAlert() {
        self.alertType = AlertType.disposableAlert
        guard let reachibilityService = self.reachibilityService  else {
            return
        }
        self.rxReachbilityState.onNext((reachibilityService.connectState.value ?? Reachability.Connection.unavailable, self.alertType))
    }
    
    func dialogAlert() {
        self.alertType = AlertType.dialogAlert
        guard let reachibilityService = self.reachibilityService  else {
            return
        }
        self.rxReachbilityState.onNext((reachibilityService.connectState.value ?? Reachability.Connection.unavailable, self.alertType))
    }
    
}
