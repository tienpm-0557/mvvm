//
//  APIService.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/24/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import Alamofire
import MVVM
import SwiftyJSON

/*
 https://api.flickr.com/services/rest?method=flickr.photos.search&api_key=dc4c20e9d107a9adfa54917799e44650&format=json&nojsoncallback=1&page=0&per_page=10&text=oke
 */

let kMTLABSecretKey: String = "#---demomvvm-xxxyyyzzzz@1231---#"

enum APIUrl {
    #if DEBUG
    static let rootURL                      = "https://api.flickr.com"
    static let mtlabRootURL                 = "http://tienpm.pythonanywhere.com"
    #elseif STAGING
    static let rootURL                      = "https://api.flickr.com"
    static let mtlabRootURL                 = "http://tienpm.pythonanywhere.com"
    #else
    static let rootURL                      = "https://api.flickr.com"
    static let mtlabRootURL                 = "http://tienpm.pythonanywhere.com"
    #endif
    /// Authorization
    static let login                        = "/login"
    static let apiFlickrSearch              = "/services/rest"
    static let apiTimeline                  = "/api/dummyTimeline"
}

struct HeaderKey {
    static let ContentType              = "Content-Type"
    static let Authorization            = "Authorization"
    static let Accept                   = "Accept"
    static let UserAgent                = "User-Agent"
    static let Language                 = "lang"
    static let TimeZone                 = "timezone"
    static let Platform                 = "platform"
    static let APIVersion               = "apiVersion"
}

struct HeaderValue {
    static let ApplicationJson                      = "application/json"
    static let ApplicationOctetStream               = "application/octet-stream"
    static let ApplicationXWWWFormUrlencoded        = "application/x-www-form-urlencoded"
    static let LanguageJP                           = "ja"
    static let LanguageEng                          = "en"
    static let PLatformIos                          = "ios"
}

public enum APIService: URLRequestConvertible {
    case login(parameters: Parameters?)
    case flickrSearch(parameters: Parameters?)
    case loadTimeline(parameters: Parameters?)

    var name: String {
        switch self {
        case .flickrSearch:
            return "Flickr Search"
        default:
            return ""
        }
    }

    var usingCache: Bool {
        switch self {
        case .flickrSearch:
            return false

        default:
            return false
        }
    }

    var parameters: Parameters? {
        switch self {
        case .flickrSearch(let parameter):
            return parameter

        case .loadTimeline(let parameter):
            return parameter

        default:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .flickrSearch:
            return .get

        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .login:
            return APIUrl.login

        case .flickrSearch:
            return APIUrl.apiFlickrSearch

        case .loadTimeline:
            return APIUrl.apiTimeline
        }
    }

    var header: HTTPHeaders? {
        switch self {
        case .login:
            return [
                HeaderKey.ContentType: HeaderValue.ApplicationJson,
                HeaderKey.Accept: HeaderValue.ApplicationJson,
                HeaderKey.Language: HeaderValue.LanguageEng,
                HeaderKey.TimeZone: TimeZone.current.identifier,
                HeaderKey.Platform: HeaderValue.PLatformIos
            ]

        default:
            return [:]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .login:
            return JSONEncoding.default

        case .flickrSearch, .loadTimeline:
            return URLEncoding.default
        }
    }

    // MARK: URLRequestConvertible
    public func asURLRequest() throws -> URLRequest {
        var url = try APIUrl.rootURL.asURL()
        switch self {
        case .loadTimeline:
            url = try APIUrl.mtlabRootURL.asURL()

        default:
            break
        }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        /// Common configuration
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = TimeInterval(30)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func prepareSources(response: APIResponse) -> APIResponse {
        print(response.cURLString())
        return response
    }
}
