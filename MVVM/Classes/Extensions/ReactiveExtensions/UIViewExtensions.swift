//
//  UIViewExtensions.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIView {
    
    var backgroundColor: Binder<UIColor> {
        return Binder(base) { $0.backgroundColor = $1 }
    }
    
    var tintColor: Binder<UIColor> {
        return Binder(base) { $0.tintColor = $1 }
    }
    
    var borderColor: Binder<UIColor> {
        return Binder(base) { $0.layer.borderColor = $1.cgColor }
    }
    
    var borderWidth: Binder<CGFloat> {
        return Binder(base) { $0.layer.borderWidth = $1 }
    }
    
    var cornerRadius: Binder<CGFloat> {
        return Binder(base) { $0.cornerRadius = $1 }
    }
    
    var tapGesture: ControlEvent<UITapGestureRecognizer> {
        var tap: UITapGestureRecognizer! = base.getGesture()
        if tap == nil {
            tap = UITapGestureRecognizer()
            base.addGestureRecognizer(tap)
        }
        
        return tap.rx.event
    }
    
    var panGesture: ControlEvent<UIPanGestureRecognizer> {
        var pan: UIPanGestureRecognizer! = base.getGesture()
        if pan == nil {
            pan = UIPanGestureRecognizer()
            base.addGestureRecognizer(pan)
        }
        
        return pan.rx.event
    }
    
    var pinchGesture: ControlEvent<UIPinchGestureRecognizer> {
        var pinch: UIPinchGestureRecognizer! = base.getGesture()
        if pinch == nil {
            pinch = UIPinchGestureRecognizer()
            base.addGestureRecognizer(pinch)
        }
        
        return pinch.rx.event
    }
    
    var longPressGesture: ControlEvent<UILongPressGestureRecognizer> {
        var longPress: UILongPressGestureRecognizer! = base.getGesture()
        if longPress == nil {
            longPress = UILongPressGestureRecognizer()
            base.addGestureRecognizer(longPress)
        }
        
        return longPress.rx.event
    }
}













