//
//  NetworkServicePageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/26/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa

class NetworkServicePageViewModel: BaseViewModel {
    
    let rxPageTitle = BehaviorRelay(value: "")
    
    override func react() {
        super.react()
        rxPageTitle.accept("Network service")
    }
    
    
}
