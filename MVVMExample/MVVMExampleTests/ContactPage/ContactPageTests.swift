//
//  ContactPageTests.swift
//  MVVMExampleTests
//
//  Created by pham.minh.tien on 8/11/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import MVVM

@testable import MVVMExample
class ContactPageTests: XCTestCase {

    private var contactViewModdel: ContactEditPageViewModel?
    private var disposeBag: DisposeBag?
    private var queueScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    private let scheduler: TestScheduler = TestScheduler(initialClock: 0)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let model = ContactModel()
        contactViewModdel = ContactEditPageViewModel(model: model, timerScheduler: scheduler)
        contactViewModdel?.react()
    }
    
    /// Implement test case
    func testContactViewInitialState() {
        let saveBtnstate = scheduler.createObserver(Bool.self)
        let nameInput = scheduler.createObserver(String?.self)
        let phoneInput = scheduler.createObserver(String?.self)
        
        guard let viewModel = self.contactViewModdel else { return }
        
        viewModel.rxSaveEnabled.bind(to: saveBtnstate) => disposeBag
        viewModel.rxName.bind(to: nameInput) => disposeBag
        viewModel.rxPhone.bind(to: phoneInput) => disposeBag
        scheduler.start()
        
        XCTAssertRecordedElements(saveBtnstate.events, [false])
        XCTAssertRecordedElements(nameInput.events, [""])
        XCTAssertRecordedElements(phoneInput.events, [""])
    }
    
    func testContactViewModelInputEmpty() {
        testSaveBtnState(nil, nil, false, message: "Test Contact View Model with case: Form data is empty")
    }
    
    func testContactViewModelNameEmpty() {
        testSaveBtnState(nil, "000-111-222", false, message: "Test Contact View Model with case: Name is empty")
    }
    
    func testContactViewModelPhoneEmpty() {
        testSaveBtnState("M.Tien", nil, false, message: "Test Contact View Model with case: Phone is empty")
    }
    
    func testContactViewModelCorrectData() {
        testSaveBtnState("M.Tien", "000-111-222", true, message: "Test Contact View Model with case: Input data correct")
    }

    private func testSaveBtnState(_ name: String?,_ phone: String?,_ expect: Bool, message: String) {
        guard let viewModel = contactViewModdel else {
            XCTAssertTrue(false)
            return
        }
        
        let btnSaveState = viewModel.isFirstEnabled.subscribeOn(queueScheduler)
        
        viewModel.rxName.accept(name)
        viewModel.rxPhone.accept(phone)
        
        // Then
        XCTAssertEqual([try btnSaveState.toBlocking().first()], [expect], message)
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}
