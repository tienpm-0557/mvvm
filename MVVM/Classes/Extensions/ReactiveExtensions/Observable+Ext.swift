//
//  Observable+Ext.swift
//  MVVM
//
//  Created by tienpm on 11/24/20.
//

import Foundation
import RxSwift
import RxCocoa

public extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
