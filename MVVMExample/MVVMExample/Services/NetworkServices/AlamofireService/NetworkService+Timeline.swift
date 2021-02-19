//
//  NetworkService+Timeline.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import MVVM
import RxSwift
import SwiftyJSON

extension NetworkService {
    func loadTimeline(withPage page: Int, withLimit limit: Int) -> Single<TimelineResponseModel> {
        let parameters: [String: Any] = [
            "page": page,
            "limie": limit
        ]
        
        return Single.create { single in
            let result = self.request(withService: APIService.loadTimeline(parameters: parameters),
                                      withHash: true,
                                      usingCache: true)
                .map({ jsonData -> TimelineResponseModel? in
                    /// Implement logic maping if need.
                    /// Maping API Response to FlickrSearchResponse object.
                    if let result = jsonData.result,
                       let dictionary = JSON(result).dictionaryObject,
                       let flickrSearchResponse = TimelineResponseModel(JSON: dictionary) {
                        flickrSearchResponse.response = JSON(result)
                        self.curlString.accept(jsonData.cURLString())
                        return flickrSearchResponse
                    }
                    return nil
                })
                .subscribe(onSuccess: { dataResponse in
                    if let response = dataResponse {
                        single(.success(response))
                    } else {
                        let err = NSError(domain: "", code: 404, userInfo: ["message": "Data not fount"])
                        single(.error(err))
                    }
                }) { error in
                    single(.error(error))
                }
            
            return result
        }
    }
}
