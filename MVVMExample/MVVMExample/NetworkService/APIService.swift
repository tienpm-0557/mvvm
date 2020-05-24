//
//  APIService.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/24/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import Alamofire

enum APIUrl {
    #if DEBUG
    static let rootURL                      = "https://dev-rooturl.com"
    #elseif STAGING
    static let rootURL                      = "https://stg-rooturl.com"
    #else
    static let rootURL                      = "https://rooturl.com"
    #endif
    /// Authorization
    static let apiLogin                    = "/api/v1/users/login"
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
    
    var name: String {
        switch self {
        case .login:
            return "login"
        default:
            return ""
        }
    }
    
    var usingCache: Bool {
        switch self {
        case .login:
            return false
        default:
            return false
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let parameter):
            return parameter
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return APIUrl.apiLogin
        }
        
    }
    
    var header: HTTPHeaders? {
//        let locale = Preferences.shared.currentLocale()
//        if locale == langEN {
//            language = HeaderValue.LanguageEng
//        }
        switch self {
        case .login:
            return [HeaderKey.ContentType: HeaderValue.ApplicationJson,
                    HeaderKey.Accept: HeaderValue.ApplicationJson,
                    HeaderKey.Language: HeaderValue.LanguageEng,
                    HeaderKey.TimeZone: TimeZone.current.identifier,
                    HeaderKey.Platform: HeaderValue.PLatformIos]
        default:
            return [:]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login:
            return JSONEncoding.default
        default: // Default with HTTPMethod GET
            return URLEncoding.default
        }
    }
    
    // MARK: URLRequestConvertible
    public func asURLRequest() throws -> URLRequest {
        let url = try APIUrl.rootURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        ///Common configuration
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = TimeInterval(30)
        
        
        switch self {
        case .login(let parameters):
            ()
        default:
            break
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
