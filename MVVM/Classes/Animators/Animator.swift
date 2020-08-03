//
//  Animator.swift
//  MVVM
//

import UIKit

open class Animator: NSObject, UIViewControllerAnimatedTransitioning  {
    
    public var isPresenting = false
    public var durartion: CGFloat = 0.25

    public convenience init(withDuration duration: CGFloat?, isPresenting present: Bool = false) {
        self.init()
        self.isPresenting = isPresenting
        if let duration = duration {
            self.durartion = duration
        }
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("Subclassess have to impleted this method")
    }
}
