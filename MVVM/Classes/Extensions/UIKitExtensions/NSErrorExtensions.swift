//
//  NSErrorExtensions.swift
//  MVVM
//

import UIKit

extension NSError {
    
    private static var domain: String {
        return Bundle.main.bundleIdentifier ?? "dd.mvvm.error"
    }
    
    static var unknown: NSError {
        return NSError(domain: domain, code: 1000, userInfo: [NSLocalizedDescriptionKey : "Unknown error occurrs."])
    }
    
    static var mappingError: NSError {
        return NSError(domain: domain, code: 1001, userInfo: [NSLocalizedDescriptionKey : "Failed to transform from json to Model."])
    }
}

