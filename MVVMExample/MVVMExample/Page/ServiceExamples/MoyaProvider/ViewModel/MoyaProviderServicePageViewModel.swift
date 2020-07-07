//
//  MoyaProviderServicePageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 6/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift
import RxCocoa
import Alamofire
import Action
import Moya
import ObjectMapper

class MoyaProviderServicePageViewModel: BaseViewModel {

    private var flickrProvider: MoyaProvider<FlickrAPI>?
    
    let rxPageTitle = BehaviorRelay(value: "")
    let rxSearchText = BehaviorRelay<String?>(value: nil)
    let rxCurlText = BehaviorRelay<String?>(value: "")
    let rxResponseText = BehaviorRelay<String?>(value: "")
    
    var page: Int = 0
    var finishedSearching: Bool = false

    override func react() {
        super.react()
        flickrProvider = DependencyManager.shared.getService()
        
        rxSearchText.do(onNext: { text in
            
        })
        .debounce(.milliseconds(500), scheduler: Scheduler.shared.mainScheduler)
        .subscribe(onNext: { [weak self] text in
            if let keyword = text {
                self?.search(withText: keyword, withPage: 0)
            }
        }) => disposeBag

    }
    
    
    func search(withText keyword: String, withPage page: Int) {
        
    }
    
    private func prepareSources(_ response: FlickrSearchResponse?) -> FlickrSearchResponse? {
        /// Mapping data if need.
        /// Create model
        return response
    }
}


