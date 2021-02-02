//
//  SideMenuAnimator.swift
//  LetsSee
//
//  Created by tienpm on 11/14/20.
//

import Foundation
import UIKit
public extension SideMenu {
    struct ContentViewShadow {
        var enabled: Bool = true
        var color = UIColor.black
        var offset = CGSize.zero
        var opacity: Float = 0.4
        var radius: Float = 8.0
        
        public init(enabled: Bool = true,
                    color: UIColor = UIColor.black,
                    offset: CGSize = CGSize.zero,
                    opacity: Float = 0.4,
                    radius: Float = 8.0) {
            self.enabled = false
            self.color = color
            self.offset = offset
            self.opacity = opacity
            self.radius = radius
        }
    }
    
    struct MenuViewEffect {
        var fade: Bool = true
        var scale: Bool = true
        var scaleBackground: Bool = true
        var parallaxEnabled: Bool = false
        var bouncesHorizontally: Bool = true
        var statusBarStyle: MTAStatusBarStyle = .black
        
        public init(fade: Bool = true,
                    scale: Bool = true,
                    scaleBackground: Bool = true,
                    parallaxEnabled: Bool = false,
                    bouncesHorizontally: Bool = true,
                    statusBarStyle: MTAStatusBarStyle = .black) {
            self.fade = fade
            self.scale = scale
            self.scaleBackground = scaleBackground
            self.parallaxEnabled = parallaxEnabled
            self.bouncesHorizontally = bouncesHorizontally
            self.statusBarStyle = statusBarStyle
        }
    }
    
    struct ContentViewEffect {
        var alpha: Float = 1.0
        var scale: Float = 0.7
        
        var landscapeOffsetX: Float = (UIDevice.current.userInterfaceIdiom == .pad) ? Float(400 - max(k_ss.width, k_ss.height) / 2) : 100
        var portraitOffsetX: Float = (UIDevice.current.userInterfaceIdiom == .pad) ? Float(400 - min(k_ss.width, k_ss.height) / 2) : 100
        var minParallaxContentRelativeValue: Float = -25.0
        var maxParallaxContentRelativeValue: Float = 25.0
        var interactivePopGestureRecognizerEnabled: Bool = true
        
        public init(alpha: Float = 1.0,
                    scale: Float = 0.7,
                    landscapeOffsetX: Float = (UIDevice.current.userInterfaceIdiom == .pad) ? Float(400 - max(k_ss.width, k_ss.height) / 2) : 30,
                    portraitOffsetX: Float = (UIDevice.current.userInterfaceIdiom == .pad) ? Float(min(k_ss.width, k_ss.height) / 2 - 400) : Float(k_ss.width / 2 - 100),
                    minParallaxContentRelativeValue: Float = -25.0,
                    maxParallaxContentRelativeValue: Float = 25.0,
                    interactivePopGestureRecognizerEnabled: Bool = true) {
            self.alpha = alpha
            self.scale = scale
            self.landscapeOffsetX = landscapeOffsetX
            self.portraitOffsetX = portraitOffsetX
            self.minParallaxContentRelativeValue = minParallaxContentRelativeValue
            self.maxParallaxContentRelativeValue = maxParallaxContentRelativeValue
            self.interactivePopGestureRecognizerEnabled = interactivePopGestureRecognizerEnabled
        }
    }
}
