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

class NetworkService {
    var tmpBag: DisposeBag?
    let curlString = BehaviorRelay<String?>(value: "")
    
    func getDefaultParams() -> [String:Any] {
        var params:[String:Any] = [String:Any]()
        params["version"] = SystemConfiguration.version
        params["build"] = SystemConfiguration.buildIndex
        return params
    }
    
    // Encode hash key for content api
    func getResultKeyAlphabeFromDict(_ objectDict:[String:Any]) -> String {
        let allKeys = objectDict.keys
        let sortedArray = allKeys.sorted {
            $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending
        }
        
        var resultKey:String = ""
        for key in sortedArray {
            if (objectDict[key] is String) {
                resultKey = resultKey + (objectDict[key] as! String)
            } else {
                resultKey = resultKey + "\(String(describing: objectDict[key]!))"
            }
        }
        return resultKey;
    }
    
    open func request(withService service: APIService,
                      withHash hash:Bool,
                      usingCache cache:Bool) -> Single<APIResponse> {

        var _params = self.getDefaultParams()
        if let subParams = service.parameters {
            for key in subParams.keys {
                _params[key] = subParams[key]
            }
        }
        
        //Hash
        if hash {
            let inputHashString = self.getResultKeyAlphabeFromDict(_params).sha1()
            _params["hash"] = inputHashString
        }
        
        let urlString = service.urlRequest!.url!.absoluteString
        
        print("DEBUG: request \(urlString)")
        return Single.create { single in
            BaseNetworkService.shared.request(urlString: urlString,
                                         method: service.method,
                                         params: service.parameters,
                                         parameterEncoding: service.encoding,
                                         additionalHeaders: service.header)
                .map(service.prepareSources)
                .subscribe(onSuccess: { (json) in
                    single(.success(json))
                }) { (error) in
                    single(.error(error))
                } => self.tmpBag
            
            return Disposables.create { }
        }
    }
    
}
