//
//  FlickrImageSearchPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/23/20.
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


class FlickrService {
//    static let shared = FlickrService()
    
    private let flickrProvider = MoyaProvider<FlickrAPI>()
    
    // Use this line to enable logging
//    private let flickrProvider = MoyaProvider<FlickrAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func search(keyword: String, page: Int) -> Single<FlickrSearchResponse> {
        return flickrProvider.rx
            .request(.search(keyword: keyword, page: page))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapObject(FlickrSearchResponse.self)
    }
}


// 1:
enum FlickrAPI {
    
    // MARK: - Cameras
    case search(keyword: String, page: Int)
}

extension FlickrAPI: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL { return URL(string: "https://api.flickr.com/services/rest")! }
    
    var path: String {
        switch self {
        case .search:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .search(let keyword, let page):
            let parameters: [String: Any] = [
                "method": "flickr.photos.search",
                "api_key": "dc4c20e9d107a9adfa54917799e44650", // please provide your API key
                "format": "json",
                "nojsoncallback": 1,
                "page": page,
                "per_page": 10,
                "text": keyword
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}

class FlickrImageSearchPageViewModel: BaseListViewModel {

    let alertService: IAlertService = DependencyManager.shared.getService()
//    var flickrService: FlickrService?
    var networkService: NetworkService?

    let rxSearchText = BehaviorRelay<String?>(value: nil)
    
    var tmpBag: DisposeBag?
    var page = 1
    var finishedSearching = false
    
    lazy var loadMoreAction: Action<Void, Void> = {
        return Action() { .just(self.loadMore()) }
    }()
    
    
    override func react() {
        super.react()
//        flickrService = DependencyManager.shared.getService()
        networkService = DependencyManager.shared.getService()
        
        rxSearchText
        .do(onNext: { text in
            self.tmpBag = nil // stop current load more if any
            self.page = 1 // reset to page 1
            self.finishedSearching = false // reset done state
            
            if !text.isNilOrEmpty {
//                self.rxIsSearching.accept(true)
                self.rxState.accept(.loadingData)
            }
        })
        .debounce(.milliseconds(500), scheduler: Scheduler.shared.mainScheduler)
        .subscribe(onNext: { [weak self] text in
            if !text.isNilOrEmpty {
                self?.doSearch(keyword: text!)
            }
        }) => disposeBag
    }
    
    
    private func doSearch(keyword: String, isLoadMore: Bool = false) {
        let bag = isLoadMore ? tmpBag : disposeBag
        /*
        flickrService?.search(keyword: keyword, page: self.page)
            .map(prepareSources)
            .subscribe(onSuccess: { [weak self] cvms in
                if isLoadMore {
                    self?.itemsSource.append(cvms, animated: false)
                } else {
                    self?.itemsSource.reset([cvms])
                }
                self?.rxState.accept(.normal)
            }, onError: { [weak self] error in
                self?.rxState.accept(.normal)
            }) => bag
         */
        /* Alamofire Network service
         */
        self.networkService?.search(withKeyword: keyword, page: page)
            .map(prepareSources)
            .subscribe(onSuccess: { [weak self](results) in
            if isLoadMore {
                self?.itemsSource.append(results, animated: false)
            } else {
                self?.itemsSource.reset([results])
            }
            self?.rxState.accept(.normal)
        }, onError: { (error) in
            
        }) => bag
        
    }
    
    
    private func loadMore() {
        if itemsSource.countElements() <= 0 || finishedSearching || self.rxState.value == .loadingMore { return }
        
        tmpBag = DisposeBag()
    
        self.rxState.accept(.loadingMore)
        page += 1
        
        doSearch(keyword: rxSearchText.value!, isLoadMore: true)
    }
    
    private func prepareSources(_ response: FlickrSearchResponse?) -> [FlickrCellViewModel] {
        guard let response = response else {
            return []
        }
        if response.stat == .fail {
            alertService.presentOkayAlert(title: "Error", message: "\(response.message)\nPlease be sure to provide your own API key from Flickr.")
        }
        
        if response.page >= response.pages {
            finishedSearching = true
        }
        
        return response.photos.toBaseCellViewModels() as [FlickrCellViewModel]
    }
    
    
}
