//
//  OptionalExtensions.swift
//  MVVM
//

import UIKit

public extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        return self == nil || self!.isEmpty
    }
}
