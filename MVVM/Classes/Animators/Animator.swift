//
//  Animator.swift
//  MVVM
//

import UIKit

open class Animator: NSObject, UIViewControllerAnimatedTransitioning  {
    
    public var isPresenting = false
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("Subclassess have to impleted this method")
    }
}
