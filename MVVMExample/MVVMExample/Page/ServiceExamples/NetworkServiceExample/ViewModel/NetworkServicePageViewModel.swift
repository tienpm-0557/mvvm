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
    
    let rxPageTitle = BehaviorRelay<String>(value: "")
    let rxSearchText = BehaviorRelay<String?>(value: nil)
    let rxCurlText = BehaviorRelay<String?>(value: "")
    let rxResponseText = BehaviorRelay<String?>(value: "")
    
    let rxSearchState = BehaviorRelay<NetworkServiceState>(value: .none)
    let rxDidSearchState = PublishRelay<NetworkServiceState>()
    
    var page: Int = 0
    
    override func react() {
        super.react()
        rxPageTitle.accept("Network service")
        // Get service
        self.networkService = DependencyManager.shared.getService()
        
        self.networkService?.curlString.bind(to: rxCurlText) => disposeBag
        
        rxSearchText.do(onNext: {[weak self] text in
            self?.page = 1
            if let keyword = text {
                self?.rxCurlText.accept("Start Request \(keyword)... ")
            } else {
                self?.rxCurlText.accept("")
            }
            if !text.isNilOrEmpty {
                self?.rxSearchState.accept(.none)
            }
        }).debounce(.microseconds(500), scheduler: Scheduler.shared.mainScheduler).subscribe(onNext: {[weak self] (text) in
            if !text.isNilOrEmpty {
                self?.search(withText: text!, withPage: 0)
            }
        }) => disposeBag
    }
    
    func search(withText keyword: String, withPage page: Int) {
        _ = networkService?.search(withKeyword: keyword, page: page)
            .map(prepareSources).subscribe(onSuccess: { [weak self] (results) in
                
            if let flickSearch = results, let desc = flickSearch.response_description {
                self?.rxResponseText.accept("Responsed: \n\(desc)")
                self?.rxSearchState.accept(.success)
            }
            self?.rxDidSearchState.accept(.success)
                
        }, onError: { (error) in
            self.rxResponseText.accept("Responsed: \n\(error)")
            self.rxSearchState.accept(.error)
            self.rxDidSearchState.accept(.error)
        })
    }
    
    private func prepareSources(_ response: FlickrSearchResponse?) -> FlickrSearchResponse? {
        /// Mapping data if need.
        /// Create model
        return response
    }
    
}
