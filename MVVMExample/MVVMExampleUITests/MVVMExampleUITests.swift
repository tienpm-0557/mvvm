//
//  MVVMExampleUITests.swift
//  MVVMExampleUITests
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import XCTest
import MVVM
import RxSwift
import RxCocoa
import MVVM

class MVVMExampleUITests: XCTestCase {
    var app: XCUIApplication?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //MARK: TabbarController
    func testTabPage() {
        app?.launch()
        guard let app = self.app else { return }
        let tabHomeQuery = app.buttons.matching(identifier: "tabhome_btn")
        // If there is at least one
        if tabHomeQuery.count > 0 {
            // We take the first one and tap it
            let firstButton = tabHomeQuery.firstMatch
            if firstButton.waitForExistence(timeout: 3) {
                firstButton.tap()
            } else {
                XCTFail("TEST:: Tab Home not found")
            }
        }
        sleep(2)
        
        if let tabbarView = self.app?.otherElements["tabbarview"] {
            
        } else {
            XCTFail("TEST:: Tabbar view not found")
        }
        
    }
    
    //MARK: Timeline screen
    func testTimeline() {
        // UI tests must launch the application that they test.
        app?.launch()
        
        if let likeButtonsQuery = self.app?.buttons.matching(identifier: "like_btn") {
            // If there is at least one
            if likeButtonsQuery.count > 0 {
                // We take the first one and tap it
                let firstButton = likeButtonsQuery.firstMatch
                XCTAssertTrue(firstButton.waitForExistence(timeout: 3))
                firstButton.tap()
            }
        }
        sleep(2)
        
        if let commentButtonsQuery = self.app?.buttons.matching(identifier: "comment_btn") {
            // If there is at least one
            if commentButtonsQuery.count > 0 {
                // We take the first one and tap it
                let firstButton = commentButtonsQuery.firstMatch
                XCTAssertTrue(firstButton.waitForExistence(timeout: 3))
                firstButton.tap()
            }
        }
        sleep(2)
        
        if let reactionButtonsQuery = self.app?.buttons.matching(identifier: "reaction_btn") {
            // If there is at least one
            if reactionButtonsQuery.count > 0 {
                // We take the first one and tap it
                let firstButton = reactionButtonsQuery.firstMatch
                XCTAssertTrue(firstButton.waitForExistence(timeout: 3))
                firstButton.tap()
            }
        }
        sleep(2)
        
        if let userInfoButtonsQuery = self.app?.buttons.matching(identifier: "userinfo_btn") {
            // If there is at least one
            if userInfoButtonsQuery.count > 0 {
                // We take the first one and tap it
                let firstButton = userInfoButtonsQuery.firstMatch
                XCTAssertTrue(firstButton.waitForExistence(timeout: 3))
                firstButton.tap()
            }
        }
        sleep(2)
        
    }
    
    func testShareAction() {
        app?.launch()
        if let shareButtonsQuery = self.app?.buttons.matching(identifier: "share_btn") {
            // If there is at least one
            if shareButtonsQuery.count > 0 {
                // We take the first one and tap it
                let firstButton = shareButtonsQuery.firstMatch
                XCTAssertTrue(firstButton.waitForExistence(timeout: 3))
                firstButton.tap()
            }
        }
        sleep(5)
    }

    /*
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
     */
}
