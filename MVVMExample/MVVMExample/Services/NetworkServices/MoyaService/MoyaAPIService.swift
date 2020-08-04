//
//  MoyaAPIService.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 8/4/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import MVVM
import Moya
import RxSwift
import RxCocoa
import ObjectMapper
import SwiftyJSON

// 1:
enum MoyaAPIService {
    // MARK: - API Flickr Search
    case flickrSearch(keyword: String, page: Int)
    // MARK: - API
}

extension MoyaAPIService: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL { return URL(string: "https://api.flickr.com/services/rest")! }
    
    var path: String {
        switch self {
        case .flickrSearch:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .flickrSearch:
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
        case .flickrSearch(let keyword, let page):
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
