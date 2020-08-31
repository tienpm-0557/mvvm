//
//  UIControlExtensions.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa

public extension UIControl {
    
    /*
     Allow a UIControl to create a custom property (2-way binding)
     */
    static func toProperty<T, ControlType: UIControl>(control: ControlType, getter: @escaping (ControlType) -> T, setter: @escaping (ControlType, T) -> ()) -> ControlProperty<T> {
        
        let values: Observable<T> = Observable.deferred { [weak control] in
            guard let existingSelf = control else {
                return Observable.empty()
            }
            
            return existingSelf.rx.controlEvent([.allEditingEvents, .valueChanged])
                .flatMap { _ in
                    return control.map { Observable.just(getter($0)) } ?? Observable.empty()
                }
                .startWith(getter(existingSelf))
        }
        
        return ControlProperty(values: values, valueSink: Binder(control) { control, value in
            setter(control, value)
        })
    }
}

extension UITabBarController {
    static func toProperty<T, ControlType: UIControl>(control: ControlType, getter: @escaping (ControlType) -> T, setter: @escaping (ControlType, T) -> ()) -> ControlProperty<T> {
        
        let values: Observable<T> = Observable.deferred { [weak control] in
            guard let existingSelf = control else {
                return Observable.empty()
            }
            
            return existingSelf.rx.controlEvent([.allEditingEvents, .valueChanged])
                .flatMap { _ in
                    return control.map { Observable.just(getter($0)) } ?? Observable.empty()
                }
                .startWith(getter(existingSelf))
        }
        
        return ControlProperty(values: values, valueSink: Binder(control) { control, value in
            setter(control, value)
        })
    }
}





