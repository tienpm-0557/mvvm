//
//  Font.swift
//  MVVM
//

import UIKit

public struct Font {
    
    private static var factoryMaps = [String: FontFactory]()
    
    // font size will use this screen width to calculate ratio
    // for different screen size
    public static var defaultScreenWidthForFontSize: CGFloat = 375
    
    public static let system = System()
    
    public static func add(_ id: String, factory: FontFactory) {
        factoryMaps[id] = factory
    }
    
    public static func get(_ id: String) -> FontFactory {
        return factoryMaps[id] ?? system
    }
}

public protocol FontFactory {
    var normalName: String { get }
    var lightName: String { get }
    var boldName: String { get }
}

public extension FontFactory {
    
    func normal(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        if let font = UIFont(name: normalName, size: shouldScale ? calculateFontSize(size) : size) {
            return font
        }
        
        return UIFont.systemFont(ofSize: shouldScale ? calculateFontSize(size) : size)
    }
    
    func light(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        if let font = UIFont(name: lightName, size: shouldScale ? calculateFontSize(size) : size) {
            return font
        }
        
        return UIFont.systemFont(ofSize: shouldScale ? calculateFontSize(size) : size, weight: .light)
    }
    
    func bold(withSize size: CGFloat, shouldScaleForScreenSize shouldScale: Bool = true) -> UIFont {
        if let font = UIFont(name: boldName, size: shouldScale ? calculateFontSize(size) : size) {
            return font
        }
        
        return UIFont.boldSystemFont(ofSize: shouldScale ? calculateFontSize(size) : size)
    }
    
    private func calculateFontSize(_ standardSize: CGFloat) -> CGFloat {
        let maxSize = standardSize + (standardSize*0.15)
        let minSize = standardSize - (standardSize*0.15)
        
        let bounds = UIScreen.main.bounds
        let ratio = bounds.width/Font.defaultScreenWidthForFontSize
        
        var fontSize = standardSize*ratio
        
        if fontSize > maxSize {
            fontSize = maxSize
        }
        
        if fontSize < minSize {
            fontSize = minSize
        }
        
        return fontSize
    }
    
}

public struct System: FontFactory {
    
    public var normalName: String {
        return ""
    }
    
    public var lightName: String {
        return ""
    }
    
    public var boldName: String {
        return ""
    }
}



