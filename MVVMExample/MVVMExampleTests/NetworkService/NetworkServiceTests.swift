//
//  NetworkServiceTests.swift
//  MVVMExampleTests
//
//  Created by pham.minh.tien on 8/11/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import MVVM
import Foundation
import Alamofire

@testable import MVVMExample

extension ParameterEncoding {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return true
    }
}

class NetworkServiceTests: XCTestCase {

    var networkPageModel: TimelinePageViewModel?
    var disposeBag: DisposeBag?
    var response: TimelineResponseModel?
    private let scheduler: TestScheduler = TestScheduler(initialClock: 0)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DependencyManager.shared.registerService(Factory<NetworkService> {
            NetworkService()
        })
        
        disposeBag = DisposeBag()

        networkPageModel = TimelinePageViewModel(model: TabbarModel(JSON: ["title": "Home", "index": 0]))
        networkPageModel?.react()
    }
    
    func testAPIService() {
        let parameters: [String: Any] = [
            "page": 0,
            "limie": 10
        ]
        
        let apiServiceTimeline = APIService.loadTimeline(parameters: parameters)
        let apiServiceLogin = APIService.login(parameters: nil)
        
        XCTAssertEqual(apiServiceTimeline.name, "loadTimeline", "API service NAME incorrect.", file: "NetworkServiceTests")
        XCTAssertEqual(apiServiceLogin.name, "", "API service NAME incorrect.", file: "NetworkServiceTests")
        
        XCTAssertEqual(apiServiceTimeline.method, .get, "API service METHOD incorrect.", file: "NetworkServiceTests")
        XCTAssertEqual(apiServiceLogin.method, .get, "API service METHOD incorrect.", file: "NetworkServiceTests")

        XCTAssertFalse(apiServiceTimeline.usingCache, "API service CACHE incorrect.", file: "NetworkServiceTests")
        XCTAssertFalse(apiServiceLogin.usingCache, "API service CACHE incorrect.", file: "NetworkServiceTests")

        XCTAssertNotNil(apiServiceTimeline.parameters, "API service PARAMETER incorrect.", file: "NetworkServiceTests")
        XCTAssertNil(apiServiceLogin.parameters, "API service PARAMETER incorrect.", file: "NetworkServiceTests")
        
        XCTAssertEqual(apiServiceTimeline.path, APIUrl.apiTimeline, "API service PARAMETER incorrect.", file: "NetworkServiceTests")
        XCTAssertEqual(apiServiceLogin.path, APIUrl.login, "API service PARAMETER incorrect.", file: "NetworkServiceTests")
        
        let timelineRequestLoginHeader = [HeaderKey.ContentType: HeaderValue.ApplicationJson,
                                          HeaderKey.Accept: HeaderValue.ApplicationJson,
                                          HeaderKey.Language: HeaderValue.LanguageEng,
                                          HeaderKey.TimeZone: TimeZone.current.identifier,
                                          HeaderKey.Platform: HeaderValue.PLatformIos]
        
        XCTAssertEqual(apiServiceTimeline.header?.dictionary, [:], "API service HEADER incorrect.", file: "NetworkServiceTests")
        XCTAssertEqual(apiServiceLogin.header?.dictionary, timelineRequestLoginHeader, "API service HEADER incorrect.", file: "NetworkServiceTests")
        
    }

    func testNetworkService() {
        
        guard let networkPageModel = networkPageModel else { return }
        let exp = expectation(description: "Loading timeline")
        /// For test net
        networkPageModel.networkService?.loadTimeline(withPage: 0, withLimit: 10).map({ response in
            response
        }).subscribe(onSuccess: { [weak self](results) in
            self?.response = results
            
            XCTAssertEqual(results.stat, .ok, "We should have loaded time line data with 20 items.", file: "NetworkServiceTests")
            exp.fulfill()
        }, onError: { (error) in
            XCTFail("Request timeline data error \(error.localizedDescription)", file: "NetworkServiceTests")
            exp.fulfill()
        }) => disposeBag
        
        waitForExpectations(timeout: 30) { (error) in
            if let err = error {
                XCTFail("Load timeline error \(err.localizedDescription)", file: "NetworkServiceTests")
            }
        }
         
    }
    
    func testNetworkServicePageViewModel() {
        
        guard let networkPageModel = networkPageModel else { return }
        /// Start case search on page View Model
        networkPageModel.getDataAction.execute()
        
        /// Detect callback did Search
        networkPageModel.rxRequestDataState.subscribe(onNext: { (state) in
            ///validate test case
            XCTAssertEqual(state, .success, "We should have loaded exactly 10 photos.")
        }, onError: { (error) in
            XCTAssertTrue(false, "MVVMTests: flickrSearch on page View Model missed ")
        }) => disposeBag

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

