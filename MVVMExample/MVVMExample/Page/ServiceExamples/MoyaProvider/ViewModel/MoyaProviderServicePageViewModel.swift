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
    private var moyaService: MoyaService?
    let rxPageTitle = BehaviorRelay(value: "")
    let rxSearchText = BehaviorRelay<String?>(value: nil)
    let rxCurlText = BehaviorRelay<String?>(value: "")
    
    let rxResponseText = BehaviorRelay<String?>(value: "")
    let rxIsSearching = BehaviorRelay<Bool>(value: false)
    
    var page: Int = 0

    override func react() {
        super.react()
        moyaService = DependencyManager.shared.getService()
        
        self.moyaService?.curlString.bind(to: rxCurlText) => disposeBag
        
        rxSearchText.do(onNext: {[weak self] _ in
            self?.rxIsSearching.accept(true)
        })
        .debounce(.milliseconds(500), scheduler: Scheduler.shared.mainScheduler)
        .subscribe(onNext: { [weak self] text in
            if let keyword = text {
                self?.search(withText: keyword, withPage: 0)
            }
        }) => disposeBag
    }
    
    func search(withText keyword: String, withPage page: Int) {
        moyaService?.search(keyword: keyword, page: 0)
            .map(prepareSources)
            .subscribe(onSuccess: {[weak self] response in
                if let flickSearch = response, let desc = flickSearch.response_description {
                    self?.rxResponseText.accept("Responsed: \n\(desc)")
                }
                self?.rxIsSearching.accept(false)
        }, onError: {[weak self] _ in
            self?.rxIsSearching.accept(false)
        })
        => disposeBag
    }
    
    private func prepareSources(_ response: FlickrSearchResponse?) -> FlickrSearchResponse? {
        /// Mapping data if need.
        /// Create model
        return response
    }
}
