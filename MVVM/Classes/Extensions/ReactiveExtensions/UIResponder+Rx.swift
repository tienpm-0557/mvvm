//
//  UIResponder+Keyboard.swift
//  MVVM
//
//  Created by tienpm on 11/13/20.
//

import Foundation
import RxCocoa
import RxSwift

public class KeyboardManager: NSObject {
    open class func keyboardHeight() -> Observable<CGFloat> {
        return Observable.from([
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                .map { notification -> CGFloat in
                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                },
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                .map { _ -> CGFloat in
                    0
                }
        ])
        .merge()
    }
}
