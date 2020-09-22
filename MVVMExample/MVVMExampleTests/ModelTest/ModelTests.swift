//
//  ModelTests.swift
//  MVVMExampleTests
//
//  Created by pham.minh.tien on 9/18/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import MVVM
import ObjectMapper

@testable import MVVMExample
class ModelTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    /// Implement test case
    func testTabbarModel() {
        let tabbarModel = TabbarModel(JSON: [:])
        XCTAssertEqual(tabbarModel?.title, "", "ActivityModel title initial is wrong")
        XCTAssertEqual(tabbarModel?.index, 0, "ActivityModel tweets initial is wrong")
        
        let tabbarModel1 = TabbarModel(withTitle: "abc")
        XCTAssertEqual(tabbarModel1?.title, "abc", "ActivityModel title initial is wrong")
        XCTAssertEqual(tabbarModel1?.index, 0, "ActivityModel tweets initial is wrong")
    }
    
    func testActivityModel() {
        /// In case: correct data input
        let activityModelCase1 = ActivityModel(JSON: ["title":"Activity Title", "tweets":1, "following": 2, "follower": 3, "likes": 4])
        XCTAssertEqual(activityModelCase1?.title, "Activity Title", "ActivityModel title initial is wrong")
        XCTAssertEqual(activityModelCase1?.tweets, 1, "ActivityModel tweets initial is wrong")
        XCTAssertEqual(activityModelCase1?.following, 2, "ActivityModel following initial is wrong")
        XCTAssertEqual(activityModelCase1?.follower, 3, "ActivityModel follower initial is wrong")
        XCTAssertEqual(activityModelCase1?.likes, 4, "ActivityModel likes initial is wrong")
        
        /// In case: init activity model with empty data
        let activityModelCase4 = ActivityModel(JSON:[:])
        XCTAssertEqual(activityModelCase4?.title, "", "ActivityModel title initial is wrong")
        XCTAssertEqual(activityModelCase4?.tweets, 0, "ActivityModel tweets initial is wrong")
        XCTAssertEqual(activityModelCase4?.following, 0, "ActivityModel following initial is wrong")
        XCTAssertEqual(activityModelCase4?.follower, 0, "ActivityModel follower initial is wrong")
        XCTAssertEqual(activityModelCase4?.likes, 0, "ActivityModel likes initial is wrong")
        
        /// In case: init activity model with miss title
        let activityModelCase2 = ActivityModel(JSON: ["tweets":1, "following": 2, "follower": 3, "likes": 4])
        XCTAssertEqual(activityModelCase2?.title, "", "ActivityModel title initial is wrong")
        XCTAssertEqual(activityModelCase1?.tweets, 1, "ActivityModel tweets initial is wrong")
        XCTAssertEqual(activityModelCase1?.following, 2, "ActivityModel following initial is wrong")
        XCTAssertEqual(activityModelCase1?.follower, 3, "ActivityModel follower initial is wrong")
        XCTAssertEqual(activityModelCase1?.likes, 4, "ActivityModel likes initial is wrong")
        
        /// In case: initialize activity model with miss tweets
        let activityModelCase3 = ActivityModel(JSON: ["title":"Activity Title", "following": 2, "follower": 3, "likes": 4])
        XCTAssertEqual(activityModelCase3?.title, "Activity Title", "ActivityModel title initial is wrong")
        XCTAssertEqual(activityModelCase3?.tweets, 0, "ActivityModel tweets initial is wrong")
        XCTAssertEqual(activityModelCase3?.following, 2, "ActivityModel following initial is wrong")
        XCTAssertEqual(activityModelCase3?.follower, 3, "ActivityModel follower initial is wrong")
        XCTAssertEqual(activityModelCase3?.likes, 4, "ActivityModel likes initial is wrong")

    }
    
    func testTimelineModel() {
        
        let json: [String: Any] = ["title": "Test title", "description": "description", "thumbnail":"thumbnail", "createDate": "createDate", "reaction":"reaction", "type":0, "user":["id":"user id", "username":"username", "displayName":"displayName", "avatar":"avatar"]]
        let timeline = TimelineModel(JSON: json)
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
