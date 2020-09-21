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

    func testExample() {
        // UI tests must launch the application that they test.
        app?.launch()
        
        if let accordianButtonsQuery = self.app?.buttons.matching(identifier: "like_btn") {
            // If there is at least one
            if accordianButtonsQuery.count > 0 {
                // We take the first one and tap it
                let firstButton = accordianButtonsQuery.element(boundBy: 0)
                firstButton.tap()
            }
        }
        
//        let service = AlertService()
//        service.presentPMConfirmAlert(title: "[Provide your title]", message: "[Provide your alert message]")

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
