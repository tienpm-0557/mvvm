//
//  AlertServices.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 7/15/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxSwift

extension AlertService {
    
    public func presentPMConfirmAlert(title: String?, message: String?, yesText: String = "Yes", noText: String = "No") -> Single<Bool> {
        return Single.create { single in
            let alertPage = AlertPage(title: title, message: message, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: yesText, style: .cancel) { _ in
                single(.success(true))
            }
            /// Set value for action
            yesAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            let noAction = UIAlertAction(title: noText, style: .default) { _ in
                single(.success(false))
            }
            
            alertPage.addAction(yesAction)
            alertPage.addAction(noAction)
            
            alertPage.show()
            
            return Disposables.create { alertPage.hide() }
        }
    }
    
}
