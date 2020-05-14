//
//  UIBarButtonItemExtensions.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIBarButtonItem {
    
    var image: Binder<UIImage?> {
        return Binder(base) { $0.image = $1 }
    }
    
    var title: Binder<String?> {
        return Binder(base) { $0.title = $1 }
    }
}










