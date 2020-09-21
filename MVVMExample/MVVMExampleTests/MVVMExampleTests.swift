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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //MARK: - Test logD
    func testLogD() {
        let result = logD("Test message")
        /// Check message
        XCTAssertNotNil(result.range(of:"Test message"), "Test LogD print message incorrect.")
        /// Check function name
        XCTAssertNotNil(result.range(of:"Func: testLogD()"), "Test LogD print func name incorrect.")
    }
    
    func testCoreData()  {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        XCTAssertNotNil(delegate, "AppDelegate not found")
        XCTAssertNotNil(delegate?.persistentContainer, "persistentContainer is Nil")
        guard let dlg = delegate else {
            XCTFail("AppDelegate is nil")
            return
        }
        dlg.saveContext()
        
        XCTAssertTrue(dlg.didSaveContextSuccess)
        guard let context = delegate?.persistentContainer.viewContext else {
            XCTFail()
            return
        }
        if context.hasChanges {
            do {
                XCTAssertNoThrow(try context.save())
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
     */
}
