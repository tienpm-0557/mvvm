//
//  ContactEditPageViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/22/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import Action
import RxSwift
import RxCocoa

class ContactEditPageViewModel: BaseViewModel {
    
    lazy var cancelAction: Action<Void, Void> = {
        return Action() {
            .just(self.navigationService.pop(with: PopOptions(popType: .dismissPopup)))
        }
    }()
    
    lazy var saveAction: Action<Void, ContactModel> = {
        return Action(enabledIf: self.rxSaveEnabled.asObservable()) {
            return self.save()
        }
    }()
    
    let rxName = BehaviorRelay<String?>(value: nil)
    let rxPhone = BehaviorRelay<String?>(value: nil)
    let rxSaveEnabled = BehaviorRelay(value: false)
    
    var isFirstEnabled: Observable<Bool> {
        return Observable.combineLatest(rxName, rxPhone) { name, phone -> Bool in
            return !name.isNilOrEmpty && !phone.isNilOrEmpty
        }
    }
    
    override func react() {
        super.react()
        
        Observable.combineLatest(rxName, rxPhone) { name, phone -> Bool in
            return !name.isNilOrEmpty && !phone.isNilOrEmpty
        } ~> rxSaveEnabled => disposeBag
        
        /// For Edit contact
        guard let model = self.model as? ContactModel else { return }
        rxName.accept(model.name)
        rxPhone.accept(model.phone)
    }
    
    func save() -> Observable<ContactModel> {
        
        let contact = ContactModel()
        contact.name = rxName.value ?? ""
        contact.phone = rxPhone.value ?? ""
        navigationService.pop(with: PopOptions(popType: .dismissPopup))
        
        return .just(contact)
    }
    
}
