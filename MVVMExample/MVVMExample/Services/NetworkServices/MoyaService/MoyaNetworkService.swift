//
//  MoyaNetworkService.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 6/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import MVVM
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON

//MARK: Guideline
///- Setting request header(authentication, contentType,....)  in MoyaAPIService.
///- Setting Enpoint In MoyaAPIService

class MoyaService {
    var tmpBag: DisposeBag?
    let curlString = BehaviorRelay<String?>(value: "")
    
    private lazy var moyaProvider = MoyaProvider<MoyaAPIService>(plugins: [
        NetworkLoggerPlugin(configuration: .init(formatter: .init(),
                                                 output: { target, array in
                                                    _ = target.method
                                                    if let curlStr = array.first, curlStr.contains("curl") {
                                                        self.curlString.accept(curlStr)
                                                    }
                                                 },
                                                 logOptions: .formatRequestAscURL))
    ])
    
    func search(keyword: String, page: Int) -> Single<FlickrSearchResponse> {
        return Single.create { single in
            self.moyaProvider.rx.request(.flickrSearch(keyword: keyword, page: page))
                .filterSuccessfulStatusCodes()
                .map({ response -> FlickrSearchResponse? in
                    /// Implement logic maping if need. Maping API Response to FlickrSearchResponse object.
                    let jsonData = JSON(response.data)
                    if let dictionary = jsonData.dictionaryObject, let flickrSearchResponse = FlickrSearchResponse(JSON: dictionary) {
                        flickrSearchResponse.response_description = jsonData
                        return flickrSearchResponse
                    }
                    return nil
                })
                .subscribe(onSuccess: { (flickrSearchResponse) in
                    if let response = flickrSearchResponse {
                        single(.success(response))
                    } else {
                        let err = NSError(domain: "", code: 404, userInfo: ["message": "Data not fount"])
                        single(.error(err))
                    }
                }) { error in
                    single(.error(error))
                } => self.tmpBag
            return Disposables.create { self.tmpBag = DisposeBag() }
        }
    }
}
