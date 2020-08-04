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
    var networkService: NetworkService?
    
    let rxPageTitle = BehaviorRelay(value: "")
    let rxSearchText = BehaviorRelay<String?>(value: nil)
    let rxCurlText = BehaviorRelay<String?>(value: "")
    let rxResponseText = BehaviorRelay<String?>(value: "")
    
    let rxIsSearching = BehaviorRelay<Bool>(value: false)

    var page: Int = 0
    var finishedSearching: Bool = false

    
    override func react() {
        super.react()
        rxPageTitle.accept("Network service")
        // Get service
        self.networkService = DependencyManager.shared.getService()
        
        self.networkService?.curlString.bind(to: rxCurlText) => disposeBag
        
        rxSearchText.do(onNext: {[weak self] text in
            self?.page = 1
            self?.finishedSearching = false
            if let keyword = text {
                self?.rxCurlText.accept("Start Request \(keyword)... ")
            } else {
                self?.rxCurlText.accept("")
            }
            if !text.isNilOrEmpty {
                self?.rxIsSearching.accept(true)
            }
        }).debounce(.microseconds(500), scheduler: Scheduler.shared.mainScheduler).subscribe(onNext: {[weak self] (text) in
            if !text.isNilOrEmpty {
                self?.search(withText: text!, withPage: 0)
            }
        }) => disposeBag
    }
    
    func search(withText keyword: String, withPage page: Int) {
        _ = networkService?.search(withKeyword: keyword, page: page).map(prepareSources).subscribe(onSuccess: { [weak self] (results) in
            if let flickSearch = results, let desc = flickSearch.response_description {
                self?.rxResponseText.accept("Responsed: \n\(desc)")
                self?.rxIsSearching.accept(false)
            }
        }, onError: { (error) in
            self.rxResponseText.accept("Responsed: \n\(error)")
            self.rxIsSearching.accept(false)
        })
    }
    
    private func prepareSources(_ response: FlickrSearchResponse?) -> FlickrSearchResponse? {
        /// Mapping data if need.
        /// Create model
        return response
    }
    
}
