//
//  StringExtensions.swift
//  MVVM
//

import UIKit
import CommonCrypto

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
    
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}




