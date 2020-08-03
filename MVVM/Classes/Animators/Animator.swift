//
//  Animator.swift
//  MVVM
//

import UIKit

open class Animator: NSObject, UIViewControllerAnimatedTransitioning  {
    
    public var isPresenting = false
    public var duration: TimeInterval = 0.25

    public convenience init(withDuration duration: TimeInterval?, isPresenting present: Bool = false) {
        self.init()
        self.isPresenting = isPresenting
        if let duration = duration {
            self.duration = duration
        }
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("Subclassess have to impleted this method")
    }
    
    public class func rectMovedIn(_ rect :CGRect, magnitude: CGFloat) -> CGRect {
        return CGRect.init(x: rect.origin.x + magnitude, y: rect.origin.y + magnitude, width: rect.size.width - magnitude * 2, height: rect.size.height - magnitude * 2)
    }
    
    public func snapshot(_ view : UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
}
