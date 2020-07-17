//
//  AlertService.swift
//  MVVM
//

import UIKit
import RxSwift

public class AlertPage: UIAlertController {
    
    private var alertWindow: UIWindow? = nil
    
    public func show() {
        let window = UIApplication.shared.keyWindow
        guard let rootViewContorller = window?.rootViewController else {
            return
        }
        rootViewContorller.present(self, animated: true)
    }
    
    public func hide() {
        alertWindow?.isHidden = true
        alertWindow = nil
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        hide()
    }
}

public protocol IAlertService {
    
    func presentOkayAlert(title: String?, message: String?)
    
    func presentObservableOkayAlert(title: String?, message: String?) -> Single<Void>
    func presentObservableConfirmAlert(title: String?, message: String?, yesText: String, noText: String) -> Single<Bool>
    func presentObservaleActionSheet(title: String?, message: String?, actionTitles: [String], cancelTitle: String) -> Single<String>
}

public class AlertService: IAlertService {
    public init() {}
    
    public func presentOkayAlert(title: String? = "OK", message: String? = nil) {
        let alertPage = AlertPage(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel)
        
        alertPage.addAction(okayAction)
        
        alertPage.show()
    }
    
    public func presentObservableOkayAlert(title: String?, message: String?) -> Single<Void> {
        return Single.create { single in
            let alertPage = AlertPage(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                single(.success(()))
            }
            
            alertPage.addAction(okayAction)
            
            alertPage.show()
            
            return Disposables.create { alertPage.hide() }
        }
    }
    
    public func presentObservableConfirmAlert(title: String?, message: String?, yesText: String = "Yes", noText: String = "No") -> Single<Bool> {
        return Single.create { single in
            let alertPage = AlertPage(title: title, message: message, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: yesText, style: .cancel) { _ in
                single(.success(true))
            }
            let noAction = UIAlertAction(title: noText, style: .default) { _ in
                single(.success(false))
            }
            
            alertPage.addAction(yesAction)
            alertPage.addAction(noAction)
            
            alertPage.show()
            
            return Disposables.create { alertPage.hide() }
        }
    }
    
    public func presentObservaleActionSheet(title: String?, message: String?, actionTitles: [String] = ["OK"], cancelTitle: String = "Cancel") -> Single<String> {
        return Single.create { single in
            let alertPage = AlertPage(title: title, message: message, preferredStyle: .actionSheet)
            
            for title in actionTitles {
                let action = UIAlertAction(title: title, style: .default) { _ in
                    single(.success(title))
                }
                alertPage.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                single(.success(cancelTitle))
            }
            alertPage.addAction(cancelAction)
            
            alertPage.show()
            
            return Disposables.create { alertPage.hide() }
        }
    }
}


















