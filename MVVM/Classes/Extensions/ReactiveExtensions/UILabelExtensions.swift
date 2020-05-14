//
//  UILabelExtensions.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UILabel {
    
    var attributedText: Binder<NSAttributedString> {
        return Binder(self.base) { $0.attributedText = $1 }
    }
    
    var textColor: Binder<UIColor> {
        return Binder(self.base) { $0.textColor = $1 }
    }
    
    var numberOfLines: Binder<Int> {
        return Binder(self.base) { $0.numberOfLines = $1 }
    }
}







