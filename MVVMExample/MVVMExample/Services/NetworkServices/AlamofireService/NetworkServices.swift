//
//  NetworkServices.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/24/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import MVVM
import RxSwift
import ObjectMapper
import SwiftyJSON
import RxCocoa

enum NetworkServiceState {
    case none
    case requesting
    case requestTimeout
    case success
    case error
}

class NetworkService {
    var tmpBag: DisposeBag?
    let curlString = BehaviorRelay<String?>(value: "")
    let state = PublishRelay<NetworkServiceState>()
    
    /// Define default parameter
    func getDefaultParams() -> [String:Any] {
        var params: [String: Any] = [String: Any]()
        params["version"] = SystemConfiguration.version
        params["build"] = SystemConfiguration.buildIndex
        return params
    }
    
    /// Encode hash key for content api
    func getResultKeyAlphabeFromDict(_ objectDict: [String: Any]) -> String {
        let allKeys = objectDict.keys
        let sortedArray = allKeys.sorted {
            $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending
        }
        
        var resultKey: String = ""
        for key in sortedArray {
            if objectDict[key] is String {
                let value = objectDict[key] as! String
                resultKey = resultKey + value
            } else {
                resultKey = resultKey + "\(String(describing: objectDict[key]!))"
            }
        }
        return  k_MTLAB_SECRET_KEY + resultKey
    }
    
    open func request(withService service: APIService,
                      withHash hash:Bool,
                      usingCache cache:Bool,
                      injectDefaulParameter defaultParamter: Bool = false) -> Single<APIResponse> {
        
        
        var _params: [String:Any] = [:]
        /// Consider inject default parameter.
        if defaultParamter {
            _params = self.getDefaultParams()
        }
        /// Update request paramter.
        if let subParams = service.parameters {
            for key in subParams.keys {
                _params[key] = subParams[key]
            }
        }
        /// Consider inject hash into parameter for authentication request
        if hash {
            let inputHashString = self.getResultKeyAlphabeFromDict(_params).sha1()
            _params["hash"] = inputHashString
        }
        
        guard let urlString = service.urlRequest?.url?.absoluteString else { return Single.create { _ in Disposables.create { } } }
        
        return Single.create { [weak self] single in
            self?.state.accept(.requesting)
            BaseNetworkService.shared.request(urlString: urlString,
                                              method: service.method,
                                              params: _params,
                                              parameterEncoding: service.encoding,
                                              additionalHeaders: service.header)
                .map(service.prepareSources)
                .subscribe(onSuccess: { [weak self](json) in
                    self?.state.accept(.success)
                    single(.success(json))
                }) { (error) in
                    self?.state.accept(.error)
                    single(.error(error))
                } => self?.tmpBag
            return Disposables.create {
                self?.tmpBag = DisposeBag()
            }
        }
    }
    
}
