//
//  MVVMExampleTests.swift
//  MVVMExampleTests
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import MVVM
@testable import MVVMExample

class MVVMExampleTests: XCTestCase {

    var networkModel: NetworkServicePageViewModel?
    var disposeBag: DisposeBag?
    var response: FlickrSearchResponse?
    private let scheduler: TestScheduler = TestScheduler(initialClock: 0)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.    
        DependencyManager.shared.registerService(Factory<NetworkService> {
            NetworkService()
        })
        
        disposeBag = DisposeBag()
         
        let model = MenuModel(withTitle: "Alamofire Network Services.",
                              desc: "Examples about how to use Alamofire Network Services.")
        
        networkModel = NetworkServicePageViewModel(model: model, timerScheduler: scheduler)
        networkModel?.react()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNetworkService() {
        guard let networkModel = networkModel else { return }
        let exp = expectation(description: "Loading stories")
        /// For test net
        _ = networkModel.networkService?.search(withKeyword: "animal", page: 0).map({ response in
            response
        }).subscribe(onSuccess: { [weak self] (results) in
            self?.response = results
            XCTAssertEqual(results.stat, .ok, "We should have loaded exactly 10 photos.")
            exp.fulfill()
        }, onError: { (error) in
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 30) { (error) in
            print("MVVMTests: search flickr error \(error.debugDescription)")
        }
    }
    
    func testNetworkServicePageViewModel() {
        guard let networkModel = networkModel else { return }
        let exp = expectation(description: "Start Testing")
        
        /// Start case search on page View Model
        networkModel.search(withText: "animal", withPage: 0)
        /// Detect callback did Search
        networkModel.rxDidSearchState.subscribe(onNext: { (state) in
            ///validate test case
            XCTAssertEqual(state, .success, "We should have loaded exactly 10 photos.")
        }, onError: { (error) in
            XCTAssertTrue(false, "MVVMTests: flickrSearch on page View Model missed ")
        }) => disposeBag
        
        let mock = MockNetworkServiceOps()
        ///In case: keyword empty
        mock.flickrSearch(withKey: "", withPage: 0).subscribe(onSuccess: { (response) in
            XCTAssertEqual(response.stat, .ok, "We should have loaded exactly 10 photos.")
        }) { (error) in
            XCTAssertTrue(false, "MVVMTests: flickrSearch with key empty missed")
        } => disposeBag
        
        ///In case: keyword not empty
        mock.flickrSearch(withKey: "animal", withPage: 0).subscribe(onSuccess: { (response) in
            XCTAssertEqual(response.stat, .ok, "We should have loaded exactly 10 photos.")
            exp.fulfill()
        }) { (error) in
            XCTAssertTrue(false, "MVVMTests: flickrSearch with key \"animal\" empty missed")
            exp.fulfill()
        } => disposeBag
        ///Waite for 30 second
        waitForExpectations(timeout: 30) { (error) in
            print("MVVMTests: search flickr error \(error.debugDescription)")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


protocol FlickrSearchOpsType {
    func flickrSearch(withKey key: String, withPage page: Int) -> Single<FlickrSearchResponse>
}

struct MockNetworkServiceOps: FlickrSearchOpsType {
    var networkService: NetworkService = DependencyManager.shared.getService()
    func flickrSearch(withKey key: String, withPage page: Int) -> Single<FlickrSearchResponse> {
        return networkService.search(withKeyword: key, page: page)
    }
}
