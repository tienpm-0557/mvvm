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
    
    private let scheduler: TestScheduler = TestScheduler(initialClock: 0)
    
    var disposeBag: DisposeBag?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    /// Implement test case
    func testTabbarModel() {
        let tabbarModel = TabbarModel(JSON: [:])
        XCTAssertEqual(tabbarModel?.title, "", "ActivityModel title initial is wrong", file: "ModelTests")
        XCTAssertEqual(tabbarModel?.index, 0, "ActivityModel tweets initial is wrong", file: "ModelTests")
        
        let tabbarModel1 = TabbarModel(withTitle: "Tab page title")
        XCTAssertEqual(tabbarModel1?.title, "Tab page title", "ActivityModel title initial is wrong", file: "ModelTests")
        XCTAssertEqual(tabbarModel1?.index, 0, "ActivityModel tweets initial is wrong", file: "ModelTests")
    }
    
    func testActivityModel() {
        /// In case: correct data input
        let activityModelCase1 = ActivityModel(JSON: ["title":"Activity Title", "tweets":1, "following": 2, "follower": 3, "likes": 4])
        XCTAssertEqual(activityModelCase1?.title, "Activity Title", "ActivityModel title initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase1?.tweets, 1, "ActivityModel tweets initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase1?.following, 2, "ActivityModel following initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase1?.follower, 3, "ActivityModel follower initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase1?.likes, 4, "ActivityModel likes initial is wrong", file: "ModelTests")
        
        /// In case: init activity model with empty data
        let activityModelCase4 = ActivityModel(JSON:[:])
        XCTAssertEqual(activityModelCase4?.title, "", "ActivityModel title initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase4?.tweets, 0, "ActivityModel tweets initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase4?.following, 0, "ActivityModel following initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase4?.follower, 0, "ActivityModel follower initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase4?.likes, 0, "ActivityModel likes initial is wrong", file: "ModelTests")
        
        /// In case: init activity model with miss title
        let activityModelCase2 = ActivityModel(JSON: ["tweets":1, "following": 2, "follower": 3, "likes": 4])
        XCTAssertEqual(activityModelCase2?.title, "", "ActivityModel title initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase1?.tweets, 1, "ActivityModel tweets initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase1?.following, 2, "ActivityModel following initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase1?.follower, 3, "ActivityModel follower initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase1?.likes, 4, "ActivityModel likes initial is wrong", file: "ModelTests")
        
        /// In case: initialize activity model with miss tweets
        let activityModelCase3 = ActivityModel(JSON: ["title":"Activity Title", "following": 2, "follower": 3, "likes": 4])
        XCTAssertEqual(activityModelCase3?.title, "Activity Title", "ActivityModel title initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase3?.tweets, 0, "ActivityModel tweets initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase3?.following, 2, "ActivityModel following initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase3?.follower, 3, "ActivityModel follower initial is wrong", file: "ModelTests")
        XCTAssertEqual(activityModelCase3?.likes, 4, "ActivityModel likes initial is wrong", file: "ModelTests")
        
    }
    
    func testTimelineModel() {
        
        let json: [String: Any] = ["title": "Test title", "description": "description", "thumbnail":"thumbnail", "createDate": "createDate", "reaction":"reaction", "type":"0", "user":["id":"user id", "username":"username", "displayName":"displayName", "avatar":"avatar"]]
        guard let timelineModel = TimelineModel(JSON: json) else { return }

        let json1: [String: Any] = ["title": "Test title", "description": "description", "thumbnail":"thumbnail", "createDate": "createDate", "reaction":"reaction", "type":"1"]
        guard let timelineModel1 = TimelineModel(JSON: json1) else { return }
        /// Check user tranform
        XCTAssertNotNil(timelineModel.user, "TimelineModel in case user not nil", file: "ModelTests")
        XCTAssertNil(timelineModel1.user, "TimelineModel in case user nil", file: "ModelTests")
        /// Check Timeline type transform
        XCTAssertEqual(timelineModel.type.message, "Normal post", file: "ModelTests")
        XCTAssertEqual(timelineModel1.type.message, "Activity view", file: "ModelTests")
        
    }
    
    ///View Model
    func testTabPageViewModel() {
        
        let viewModel = TabPageViewModel(model: TabbarModel(JSON: ["title":"Title", "index":0]))
        viewModel.react()
        /// Tạo một TestableObserver để ghi lại các event trong bối cảnh test.
        let titleScheduler = scheduler.createObserver(String.self)
        /// Lấy viewmodel ra để tiến hành test
        /// Binding TestableObserver với rxTille là một BehaviorRelay trên viewmodel.
        viewModel.rxTille
            .asDriver()
            .drive(titleScheduler) => disposeBag
        /// Tạo một kịch bản test tại thời điểm nextTime 10, 15 emit value "Title 10", "Title 15"
        scheduler.createColdObservable([.next(10, "Title 10"),
                                        .next(15, "Title 15")])
            .bind(to: viewModel.rxTille) => disposeBag

        scheduler.start()
        /// Với BehaviorRelay events nhận thêm một latest event nữa.
        /// Tiến hành so sánh kết quả nhận được với giá trị mong đợi
        XCTAssertEqual(titleScheduler.events, [
            .next(0, "Title"),
            .next(10, "Title 10"),
            .next(15, "Title 15")
        ])
        
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
