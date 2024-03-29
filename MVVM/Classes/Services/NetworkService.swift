//
//  NetworkService.swift
//  MVVM
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift

/// Base network service, using SessionManager from Alamofire
open class BaseNetworkService: SessionDelegate {
    public static var shared = BaseNetworkService()
    
    public let sessionManager: Session
    private let sessionConfiguration: URLSessionConfiguration = .default
    
    public var timeout: TimeInterval = 30 {
        didSet { sessionConfiguration.timeoutIntervalForRequest = timeout }
    }
    
    var defaultHeaders: HTTPHeaders = [:]
    
    // Disables all evaluation which in turn will always consider any server trust as valid.
    /*
     Example: "domain.com": DisabledEvaluator()
    */
    let manager = ServerTrustManager(evaluators: [:])
    
    public init() {
        sessionConfiguration.timeoutIntervalForRequest = timeout
        
        sessionManager = Session(configuration: sessionConfiguration)
    }
    
    public func callRequest(urlString: String,
                            method: HTTPMethod,
                            params: [String: Any]? = nil,
                            parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                            additionalHeaders: HTTPHeaders? = nil) -> Single<String> {
        return Single.create { single in
            let headers = self.makeHeaders(additionalHeaders)
            let request = self.sessionManager.request(urlString,
                                                      method: method,
                                                      parameters: params,
                                                      encoding: encoding,
                                                      headers: headers)
            
            request.responseString { response in
                /// set status code
                /// Check result
                switch response.result {
                case .success(let result):
                    /// Implement the completion block with parameters
                    single(.success(result))
                    
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    @discardableResult
    public func request(urlString: String,
                            method: HTTPMethod,
                            params: [String: Any]? = nil,
                            parameterEncoding encoding: ParameterEncoding = URLEncoding.default,
                            additionalHeaders: HTTPHeaders? = nil) -> Single<APIResponse> {
        return Single.create { single in
            let headers = self.makeHeaders(additionalHeaders)
            let result = APIResponse()
            
            result.request = self.sessionManager.request(urlString,
                                                         method: method,
                                                         parameters: params,
                                                         encoding: encoding,
                                                         headers: headers)
            result.completeBlock { _, _ in
                debugPrint(result.request)
                single(.success(result))
            }

            result.errorBlock { error in
                debugPrint(result.request)
                debugPrint(error.localizedDescription)
                /// Handle with result.statusCode
                single(.success(result))
            }
            
            return Disposables.create {
                result.request.cancel()
            }
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

public enum HttpStatusCode: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case dataNotFound = 404
    case unAcceptable = 406
    case serviceUnavailable = 503
    case requestTimeOut = 408
    
    init?(statusCode: Int?) {
        guard let stCode = statusCode else {
            return nil
        }
        self.init(rawValue: stCode)
    }
    
    var message: String {
        switch self {
        case .ok:
            return "The request has succeeded"
        case .badRequest:
            return "Bad Request."
        case .unauthorized:
            return "Unauthorized."
        case .dataNotFound:
            return "Not Found"
        case .unAcceptable:
            return "Not Acceptable"
        case .serviceUnavailable:
            return "Service Unavailable"
        case .requestTimeOut:
            return "Request timeout"
        }
    }
}

typealias CompletionBlock = (_ result: AnyObject?, _ usingCache: Bool) -> Void
typealias ErrorBlock = (_ error: Error) -> Void

open class APIResponse {
    public var result: AnyObject?
    public var statusCode: HttpStatusCode?
    public var usingCache: Bool = false
    public var params: [String: Any]?

    private var requestData: DataRequest?
    private var onComplete: CompletionBlock?
    private var onError: ErrorBlock?

    func completeBlock(onComplete:@escaping CompletionBlock) {
        self.onComplete = onComplete
        if self.usingCache {
            self.getDataFromCache()
        }
    }
    
    func errorBlock(onError:@escaping ErrorBlock) {
        self.onError = onError
    }

    var request: DataRequest {
        get {
            return requestData!
        }
        set (newVal) {
            newVal.responseJSON { response in
                self.statusCode = HttpStatusCode(statusCode: response.response?.statusCode)
                switch response.result {
                case .success(let result):
                    self.result = result as AnyObject
                    self.onComplete?(self.result, false)

                case .failure(let error):
                    self.onError?(error)
                }
            }
            requestData = newVal
        }
    }

    public func cURLString() -> String {
        if let request = self.requestData {
            return request.cURLDescription()
        }
        return ""
    }

    func cacheAPI(_ object: AnyObject) {}

    func getDataFromCache() {}
}
