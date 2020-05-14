//
//  StringExtensions.swift
//  MVVM
//

import UIKit

public extension String {
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    func toURLRequest() -> URLRequest? {
        if let url = toURL() {
            return URLRequest(url: url)
        }
        return nil
    }
    
    func toHex() -> Int? {
        return Int(self, radix: 16)
    }
    
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}




