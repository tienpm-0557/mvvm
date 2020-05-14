//
//  UIColorExtensions.swift
//  MVVM
//

import UIKit

public extension UIColor {
    
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init?(hexString: String) {
        var hexString = hexString.replacingOccurrences(of: "#", with: "")
        if hexString.count == 3 {
            hexString += hexString
        }
        guard let hex = hexString.toHex() else { return nil }
        self.init(hex: hex)
    }
    
    static func fromHex(_ hexString: String) -> UIColor {
        return UIColor(hexString: hexString) ?? .clear
    }
}










