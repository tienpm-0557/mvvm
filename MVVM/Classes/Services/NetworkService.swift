//
//  NetworkService.swift
//  MVVM
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift

/// Base network service, using SessionManager from Alamofire
open class NetworkService: SessionDelegate {
    
    public let sessionManager: Session
    private let sessionConfiguration: URLSessionConfiguration = .default
    
    public var timeout: TimeInterval = 30 {
        didSet { sessionConfiguration.timeoutIntervalForRequest = timeout }
    }
    
    let baseUrl: String
    var defaultHeaders: HTTPHeaders = [:]
    
    public init(baseUrl: String) {
        self.baseUrl = baseUrl
        
        sessionConfiguration.timeoutIntervalForRequest = timeout
        sessionManager = Session(configuration: sessionConfiguration)
    }
    
    public func callRequest(_ path: String,
                            method: HTTPMethod,
                            params: [String: Any]? = nil,
                            parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                            additionalHeaders: HTTPHeaders? = nil) -> Single<String> {
        return Single.create { single in
            let headers = self.makeHeaders(additionalHeaders)
            let request = self.sessionManager.request(
                "\(self.baseUrl)/\(path)",
                method: method,
                parameters: params,
                encoding: encoding,
                headers: headers)
            
            request.responseString { (response) in
                //set status code
                //Check result
                switch response.result {
                case .success(let result):
                    //Implement the completion block with parameters
                    single(.success(result))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    private func makeHeaders(_ additionalHeaders: HTTPHeaders?) -> HTTPHeaders {
        var headers = defaultHeaders
        
        if let additionalHeaders = additionalHeaders {
            additionalHeaders.forEach { pair in
                headers[pair.name] = pair.value
            }
        }
        
        return headers
    }
}
