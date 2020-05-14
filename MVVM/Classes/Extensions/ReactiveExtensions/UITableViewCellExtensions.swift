//
//  UITableViewCellExtensions.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UITableViewCell {
    
    var accessoryType: Binder<UITableViewCell.AccessoryType> {
        return Binder(self.base) { $0.accessoryType = $1 }
    }
    
    var selectionStyle: Binder<UITableViewCell.SelectionStyle> {
        return Binder(self.base) { $0.selectionStyle = $1 }
    }
}







