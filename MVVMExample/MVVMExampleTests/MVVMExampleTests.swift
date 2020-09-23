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
import LocalAuthentication

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
        XCTAssertNotNil(result.range(of:"Test message"), "TEST:: Test LogD print message incorrect.")
        /// Check function name
        XCTAssertNotNil(result.range(of:"Func: testLogD()"), "TEST:: Test LogD print func name incorrect.")
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
        
        let deviceName = DeviceManager.getDeviceName()
        XCTAssertNotEqual(deviceName, "", "TEST:: Device manager get device name incorrect")
        
        let deviceSystemName = DeviceManager.getDeviceSystemName()
        XCTAssertNotEqual(deviceSystemName, "", "TEST:: Device manager get device system name incorrect")
        
        let deviceID = DeviceManager.getDeviceID()
        XCTAssertNotEqual(deviceID, "", "TEST:: Device manager get device id incorrect")
        
        let winSize = DeviceManager.getWinSize()
        XCTAssertNotEqual(winSize, CGSize.zero, "TEST:: Device manager get screen size incorrect")
        
        let winFrame = DeviceManager.getWinFrame()
        XCTAssertNotEqual(winFrame, CGRect.zero, "TEST:: Device manager get screen frame incorrect")
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let isIphone = DeviceManager.isIphone()
            XCTAssertTrue(isIphone, "TEST:: Device manager check isIphone incorrent")
            let isiPad = DeviceManager.isIpad()
            XCTAssertFalse(isiPad, "TEST:: Device manager check isIpad incorrent")
        } else {
            let isIphone = DeviceManager.isIphone()
            XCTAssertFalse(isIphone, "TEST:: Device manager check isIphone incorrent")
            let isiPad = DeviceManager.isIpad()
            XCTAssertTrue(isiPad, "TEST:: Device manager check isIpad incorrent")
        }
        
        XCTAssertNotEqual(DeviceManager.ScreenSize.SCREEN_WIDTH, 0, "TEST:: Device manager get device screen width incorrect")
        XCTAssertNotEqual(DeviceManager.ScreenSize.SCREEN_HEIGHT, 0, "TEST:: Device manager get device screen height incorrect")
        XCTAssertNotEqual(DeviceManager.ScreenSize.SCREEN_MAX_LENGTH, 0, "TEST:: Device manager get device max screen size incorrect")
        XCTAssertNotEqual(DeviceManager.ScreenSize.SCREEN_MIN_LENGTH, 0, "TEST:: Device manager get device min screen size incorrect")
        
        XCTAssertNotEqual(DeviceManager.DeviceType.SCREEN_WIDTH, 0, "TEST:: Device manager get device type screen width incorrect")
        XCTAssertNotEqual(DeviceManager.DeviceType.SCREEN_HEIGHT, 0, "TEST:: Device manager get device type screen height incorrect")
        XCTAssertNotEqual(DeviceManager.DeviceType.SCREEN_MAX_LENGTH, 0, "TEST:: Device manager get device type max screen size incorrect")
        XCTAssertNotEqual(DeviceManager.DeviceType.SCREEN_MIN_LENGTH, 0, "TEST:: Device manager get device type min screen size incorrect")
        
        
        XCTAssertTrue(DeviceManager.detectInternet(), "TEST:: Device manager check internet incorrent")
        
        let path = DeviceManager.getDirectPath()
        XCTAssertNotNil(path.range(of:"Documents"), "TEST:: Test LogD print message incorrect.")
        let pathData = DeviceManager.getPathDataFolder().absoluteString
        XCTAssertNotNil(pathData.range(of:"Documents/data"), "TEST:: Test LogD print message incorrect.")
        
        let laContext = LAContext()
        var error: NSError?
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            XCTAssertTrue(DeviceManager.touchIDAviable(), "TEST:: Device manager check touchId avaiable incorrent")
        } else {
            XCTAssertFalse(DeviceManager.touchIDAviable(), "TEST:: Device manager check touchId avaiable incorrent")
        }
        
        ///
        XCTAssertNotEqual(DeviceManager.sizeOfFolderInFormatStr(path), "", "TEST:: Device manager get size of folder incorrent")
        if DeviceManager.DeviceType.IS_IPHONE_X {
            XCTAssertNotEqual(DeviceManager.safeAreaBottomInsets(), 0, "TEST:: Device manager get safe area bottom inset incorrent")
        } else {
            XCTAssertEqual(DeviceManager.safeAreaBottomInsets(), 0, "TEST:: Device manager get safe area bottom inset incorrent")
        }
        
        XCTAssertNil(DeviceManager.getListFileOfFolder(DeviceManager.getPathDataFolder()), "TEST:: Device manager get list folder inside data incorrent")
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        XCTAssertNotNil(DeviceManager.getListFileOfFolder(documentsURL))
        if let folders = DeviceManager.getListFileOfFolder(documentsURL) {
            XCTAssertTrue(folders.isEmpty, "TEST:: Device manager get list folder inside data incorrent")
        }
    }
    
    func testTabPage() {
        let vm = TabPageViewModel(model: TabbarModel(JSON: ["title":"Home", "index":0]))
        let tabPage = TabPage(viewModel: vm)
        /// Bind view and View Model
        tabPage.initialize()
        /// Start update data
        vm.react()
        /// Start check test case
        if let title = tabPage.title {
            XCTAssertEqual(title, "Home", "TEST:: Home title incorrect")
        } else {
            XCTFail("TEST:: Home title is nil")
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
