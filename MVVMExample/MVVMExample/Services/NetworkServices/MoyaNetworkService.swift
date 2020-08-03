//
//  MoyaNetworkService.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 6/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import Moya
import RxSwift

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
