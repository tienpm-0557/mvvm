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


//MARK: ViewModel For Transition Examples
class ReachabilityPageViewModel: BaseViewModel {
    
    let rxPageTitle = BehaviorRelay<String>(value: "")
    let rxLabelContent = BehaviorRelay<String?>(value: nil)
    
    var reachability: Reachability?
    
    override func react() {
        super.react()
        let title = "Reachability Examples"
        let labelContent = "Turn off your internet connection to see update"
        rxPageTitle.accept(title)
        rxLabelContent.accept(labelContent)
        ReachabilityService.share.startReachability("status bar")
        ReachabilityService.share.connectState.subscribe(onNext: { (state) in
            self.rxLabelContent.accept(state?.description  ?? "")
        }) => disposeBag
//        self.startReachability()
    }
    
    
    func startReachability() {
        do {
            reachability = try Reachability()
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        reachability?.whenReachable = { reachability in
            self.rxLabelContent.accept(reachability.connection.description)
        }
        
        reachability?.whenUnreachable = { _ in
            self.rxLabelContent.accept("not reachable")
        }
    }
    
}
